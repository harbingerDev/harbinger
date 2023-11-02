const fs = require("fs");
const path = require("path");
const glob = require("glob");
const locAction = require("../playwrightActionLocators.json");
const dataRepo = require("./dataRepoHelper");

const objectRepositoryPath = path.join(__dirname, "objectRepository.json");
const testFilesPattern = path.join(__dirname, "tests", "**", "*.js");

function readObjectRepository() {
  const rawData = fs.readFileSync(objectRepositoryPath);
  return JSON.parse(rawData);
}

function writeObjectRepository(updatedObjectRepository) {
  fs.writeFileSync(
    objectRepositoryPath,
    JSON.stringify(updatedObjectRepository)
  );
}

function isDuplicate() {
  const objectRepo = readObjectRepository();
  const defaultFunctions = objectRepo.default;
  const duplicates = {};

  for (const pageKey in objectRepo) {
    if (pageKey === "default") continue;

    for (const key in defaultFunctions) {
      const func = defaultFunctions[key];

      if (
        objectRepo[pageKey][key] &&
        objectRepo[pageKey][key].toString() === func.toString()
      ) {
        if (!duplicates[key]) {
          duplicates[key] = [];
        }
        duplicates[key].push(pageKey);
      }
    }
  }

  return duplicates;
}

function move(sourcePage, destinationPage, keys) {
  const objectRepo = readObjectRepository();

  if (
    !objectRepo.hasOwnProperty(sourcePage) ||
    !objectRepo.hasOwnProperty(destinationPage)
  ) {
    console.log("Source or destination page does not exist");
    return;
  }

  keys.forEach((key) => {
    if (objectRepo[sourcePage].hasOwnProperty(key)) {
      objectRepo[destinationPage][key] = objectRepo[sourcePage][key];
      delete objectRepo[sourcePage][key];
    }
  });

  writeObjectRepository(objectRepo);
}

function rename(pageName, oldKeyName, newKeyName) {
  const objectRepo = readObjectRepository();

  if (!objectRepo.hasOwnProperty(pageName)) {
    console.log("Page does not exist");
    return false;
  }

  if (objectRepo[pageName].hasOwnProperty(oldKeyName)) {
    if (objectRepo[pageName].hasOwnProperty(newKeyName)) {
      console.log("New key name already exists");
      return false;
    } else {
      objectRepo[pageName][newKeyName] = objectRepo[pageName][oldKeyName];
      delete objectRepo[pageName][oldKeyName];
      writeObjectRepository(objectRepo);
      return true;
    }
  } else {
    console.log("Old key name does not exist");
    return false;
  }
}

function update(pageName, key, newValue) {
  const objectRepo = readObjectRepository();

  if (!objectRepo.hasOwnProperty(pageName)) {
    console.log("Page does not exist");
    return;
  }

  objectRepo[pageName][key] = newValue.toString();
  writeObjectRepository(objectRepo);
}

function deleteFunction(pageName, keyName) {
  const objectRepo = readObjectRepository();

  if (!objectRepo.hasOwnProperty(pageName)) {
    console.log("Page does not exist");
    return false;
  }

  const testFiles = glob.sync(testFilesPattern);
  let isFunctionUsed = false;

  for (const testFile of testFiles) {
    const content = fs.readFileSync(testFile, "utf-8");
    if (content.includes(`objectRepository.${pageName}.${keyName}`)) {
      isFunctionUsed = true;
      break;
    }
  }

  if (!isFunctionUsed) {
    delete objectRepo[pageName][keyName];
    writeObjectRepository(objectRepo);
    return true;
  } else {
    console.log(
      `Function '${keyName}' is being used in test files and cannot be deleted.`
    );
    return false;
  }
}

function addPage(pageName) {
  const objectRepo = readObjectRepository();

  if (objectRepo.hasOwnProperty(pageName)) {
    console.log("Page already exists");
    return false;
  } else {
    objectRepo[pageName] = {};
    writeObjectRepository(objectRepo);
    return true;
  }
}

function addObject(pageName, key, func) {
  const objectRepo = readObjectRepository();

  if (!objectRepo.hasOwnProperty(pageName)) {
    console.log("Page does not exist");
    return false;
  }

  if (objectRepo[pageName].hasOwnProperty(key)) {
    console.log("Key already exists");
    return false;
  } else {
    objectRepo[pageName][key] = func.toString();
    writeObjectRepository(objectRepo);
    return true;
  }
}
// above this need to be changed
function createObjectRepositoryFile(filePath) {
  const content = `const objectRepository = {
    default: {
    },
  };
  
  module.exports = objectRepository;
  `;

  const targetPath = path.join(filePath, "objectRepository.js");
  fs.writeFileSync(targetPath, content);
}

async function addControlsToPage(filePath, pageName, jsonObjectArray) {
  delete require.cache[require.resolve(filePath)];
  // Get the objectRepository object
  const objectRepository = require(filePath);

  let newRepoObject = { ...objectRepository };
  // Ensure the specified page object exists
  if (!newRepoObject[pageName]) {
    newRepoObject[pageName] = {};
  }

  // Add the JSON object key-value pairs to the specified page object
  jsonObjectArray.forEach((jsonObject) => {
    newRepoObject[pageName][jsonObject["key"]] = jsonObject["value"];
  });

  // Construct the updated content string
  let updatedContent = `const objectRepository = {\n`;

  for (const page in newRepoObject) {
    updatedContent += `  "${page}": {\n`;

    for (const key in newRepoObject[page]) {
      const value = newRepoObject[page][key];
      const valueString =
        typeof value === "function" ? value.toString() : JSON.stringify(value);
      updatedContent += `    "${key}": ${valueString},\n`;
    }

    updatedContent += `  },\n`;
  }

  updatedContent += `};\nmodule.exports = objectRepository;`;
  updatedContent = updatedContent.replace(/\\(?=")/g, "");
  // Write the updated content back to the file
  fs.writeFileSync(filePath, updatedContent, "utf8");
}

async function replaceLocatorsInScript(
  filePath,
  replacements,
  scriptPath,
  dataRepoPath
) {
  fs.readFile(filePath, "utf8", (err, data) => {
    if (err) {
      console.error(err);
      return;
    }

    let updatedData = data;

    for (const { toBeReplaced, toBeReplacedWith } of replacements) {
      updatedData = updatedData.replace(toBeReplaced, toBeReplacedWith);
    }

    fs.writeFile(filePath, updatedData, "utf8", (err) => {
      if (err) {
        console.error(err);
      } else {
        console.log("File updated successfully");
        dataRepo.updateDataRepositoryFile(scriptPath, dataRepoPath);
      }
    });
  });
}

async function removeQuotes(filePath) {
  const fileContent = fs.readFileSync(filePath, "utf8");

  const updatedContent = fileContent.replace(
    /"(\(page\) => .+?);"/g,
    function (_, functionString) {
      return functionString;
    }
  );

  fs.writeFileSync(filePath, updatedContent);
}
function getLocatorName(input) {
  // Extract the type
  let typeRegex =
    /getBy(Role|Label|Text|TestId|Placeholder)\("|page\.locator\("/;
  let typeMatch = input.match(typeRegex);
  let type = typeMatch ? typeMatch[1] && typeMatch[1].toLowerCase() : null;

  // Extract the label, name, or selector
  let labelRegex = /getByLabel\("(.+?)"(, { exact: true })?\)/;
  let roleRegex = /getByRole\(".+?", { name: "(.+?)"(, exact: true)? }\)/;
  let textRegex = /getByText\("(.+?)"(, { exact: true })?\)/;
  let placeholderRegex = /getByPlaceholder\("(.+?)"\)/;
  let locatorRegex = /page\.locator\("([.#]?)(.+?)"\)/;

  let match =
    input.match(labelRegex) ||
    input.match(roleRegex) ||
    input.match(textRegex) ||
    input.match(placeholderRegex) ||
    input.match(locatorRegex);

  if (!match) {
    return "unknown_locator_name";
  }

  let label = match[2] || match[1];

  // Format the extracted string
  switch (type) {
    case "role":
      let roleTypeRegex = /getByRole\("(.+?)",/;
      let roleTypeMatch = input.match(roleTypeRegex);
      type = roleTypeMatch ? roleTypeMatch[1].toLowerCase() : null;
      label = label
        .replace(/[^\w\s]+/g, "")
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "_");
      break;
    case "label":
    case "text":
    case "placeholder":
      label = label
        .replace(/[^\w\s]+/g, "")
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "_");
      break;
    case "testid":
      // you can add any specific format here if needed
      break;
    default:
      // For locators, just return the label directly
      return label;
  }

  return `${type}_${label}`;
}

async function getControlsFromGodJSON(
  godJSON,
  repoPath,
  scriptPath,
  dataRepoPath
) {
  let locatorNameMap = {};
  let locatorJSONArray = [];
  let replacementJSONArray = [];
  godJSON["testBlockArray"].forEach((testBlock) => {
    testBlock["testStepsArray"].forEach((testStep) => {
      if (testStep["tokens"].includes("goto")) {
      } else if (
        /^(page\d*Promise)$/.test(
          testStep["tokens"][testStep["tokens"].length - 1]
        )
      ) {
      } else if (
        testStep["tokens"][testStep["tokens"].length - 1] === "waitForLoadState"
      ) {
      } else if (testStep["tokens"].includes("waitForEvent")) {
      } else {
        const locatorObjectLast = findHighestIndexInArrayB(
          locAction.locatorsFiltered,
          testStep["tokens"]
        );
        const locatorStrategyLast = locatorObjectLast.value;
        const locatorValueLast =
          testStep["tokens"][locatorObjectLast.index + 1];
        const locatorObjectFirst = findEarliestIndexInArrayB(
          locAction.locatorsFiltered,
          testStep["tokens"]
        );
        const locatorStrategyFirst = locatorObjectFirst.value;
        const locatorValueFirst =
          testStep["tokens"][locatorObjectFirst.index + 1];
        const operator = testStep["tokens"][locatorObjectFirst.index - 1];
        const overallControl = `(page) => page.${joinWithAlternatingParentheses(
          testStep["tokens"],
          locatorObjectFirst.index,
          locatorObjectLast.index + 1
        )};`;
        // .split('\\"')
        // .join('"');
        let locatorName = getLocatorName(overallControl);
        if (locatorName === "unknown_locator_name") {
          locatorName = generateLocatorName();
        } else {
          //logic to check if the locatorName is there in locatorNameMap and if it is there then add a number to it
          if (locatorNameMap[locatorName]) {
            locatorName = locatorName + "_" + locatorNameMap[locatorName];
            locatorNameMap[locatorName] = locatorNameMap[locatorName] + 1;
          }
        }
        console.log("*******", testStep["tokens"]);
        const controlToBeReplaced =
          `${operator}.${joinWithAlternatingParentheses(
            testStep["tokens"],
            locatorObjectFirst.index,
            locatorObjectLast.index + 1
          )}`.replace(/\\(?=")/g, "");
        const controlToBeReplacedWith =
          `objectRepository.default.${locatorName}(${operator})`.replace(
            /\\(?=")/g,
            ""
          );
        console.log(controlToBeReplaced);
        const locatorJSON = {};
        locatorJSON["key"] = locatorName;
        locatorJSON["value"] = overallControl;
        locatorJSONArray.push(locatorJSON);
        const replacementJSON = {
          toBeReplaced: controlToBeReplaced,
          toBeReplacedWith: controlToBeReplacedWith,
        };
        replacementJSONArray.push(replacementJSON);
      }
    });
  });
  await addControlsToPage(repoPath, "default", locatorJSONArray);
  await removeQuotes(repoPath);

  await replaceLocatorsInScript(
    scriptPath,
    replacementJSONArray,
    scriptPath,
    dataRepoPath
  );
}

function generateLocatorName() {
  const randomNumber = Math.floor(Math.random() * 1000000); // You can adjust the range of the random number if needed
  const locatorName = `locator_${randomNumber}`;
  return locatorName;
}
function joinWithAlternatingParentheses(array, firstIndex, lastIndex) {
  let result = "";

  for (let i = firstIndex; i <= lastIndex; i++) {
    const value = array[i];
    if ((i - firstIndex) % 2 === 0) {
      result += value;
    } else {
      if (i !== lastIndex) {
        result += `(${value}).`;
      } else {
        result += `(${value})`;
      }
    }
  }

  return result;
}
function findHighestIndexInArrayB(arrayA, arrayB) {
  let highestIndex = -1;
  let valueWithHighestIndex;

  arrayA.forEach((value) => {
    const indexInArrayB = arrayB.indexOf(value);
    if (indexInArrayB > highestIndex) {
      highestIndex = indexInArrayB;
      valueWithHighestIndex = value;
    }
  });

  return {
    value: valueWithHighestIndex,
    index: highestIndex,
  };
}
function findEarliestIndexInArrayB(arrayA, arrayB) {
  let earliestIndex = Infinity;
  let valueWithEarliestIndex;

  arrayA.forEach((value) => {
    const indexInArrayB = arrayB.indexOf(value);
    if (indexInArrayB !== -1 && indexInArrayB < earliestIndex) {
      earliestIndex = indexInArrayB;
      valueWithEarliestIndex = value;
    }
  });

  return {
    value: valueWithEarliestIndex,
    index: earliestIndex === Infinity ? -1 : earliestIndex,
  };
}

module.exports = {
  isDuplicate,
  move,
  rename,
  update,
  deleteFunction,
  addPage,
  addObject,
  createObjectRepositoryFile,
  getControlsFromGodJSON,
  findHighestIndexInArrayB,
  findEarliestIndexInArrayB,
  joinWithAlternatingParentheses,
  generateLocatorName,
};
