const express = require("express");
const fs = require("fs");
const glob = require("glob");
const { parse } = require("path");
const requireFromString = require("require-from-string");
const path = require("path");
const app = express();
const bodyParser = require("body-parser");
const db = require("./db/harbinger");
const cors = require("cors");
const os = require("os");
const { exec } = require("child_process");
app.use(
  cors({
    origin: "*",
  })
);
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(function (err, req, res, next) {
  console.error(err.stack);
  res.status(500).send("Something broke!");
});

//Everything related to projects
app.get("/projects/getProjects", async (req, res) => {
  const projects = await db.getAllProjects();
  res.status(200).json(projects);
});
app.get("/projects/getActiveProject", async (req, res) => {
  const id = await db.getActiveProject();
  res.status(200).json(id);
});

app.post("/projects/createProject", async (req, res) => {
  const results = await db.createProject(req.body);
  res.status(201).json({ id: results[0] });
});

app.put("/projects/activate/:id", async (req, res) => {
  const id = await db.activateProject(req.params.id);
  res.status(200).json({ id });
});

app.delete("/projects/delete/:id", async (req, res) => {
  const id = await db.deleteProject(req.params.id);
  res.status(200).json({ success: true });
});

//Everything related to scripts
app.post("/scripts/createScript", async (req, res) => {
  const results = await db.createScript(req.body);
  res
    .status(results === true ? 201 : 500)
    .json(results === true ? { success: true } : { success: false });
});
app.post("/scripts/getScripts", async (req, res) => {
  const scripts = await db.getScripts(req.body);
  res.status(200).json(scripts);
});

//Everything related to runs
app.post("/runs/executeScript", async (req, res) => {
  const results = await db.executeScript(req.body);
  res
    .status(results === true ? 201 : 500)
    .json(results === true ? { success: true } : { success: false });
});
app.post("/runs/executeScripts", async (req, res) => {
  const results = await db.executeScripts(req.body);
  res
    .status(results === true ? 201 : 500)
    .json(results === true ? { success: true } : { success: false });
});

//everything related to system
app.get("/system/checkNodeVersion", async (req, res) => {
  const nodeVersion = await db.checkNodeVersion();
  res.status(200).json({ nodeVersion });
});

app.get("/system/checkGitVersion", async (req, res) => {
  const gitVersion = await db.checkGitVersion();
  res.status(200).json({ gitVersion });
});

//AST related
app.post("/ast/getASTFromFile", async (req, res) => {
  const ast = await db.getASTFromFile(req.body);
  res.status(201).json(ast);
});
app.post("/ast/getGodJSON", async (req, res) => {
  const ast = await db.getGodJSON(req.body);
  res.status(201).json(ast);
});

app.post("/ast/getSpecificJSON", async (req, res) => {
  const ast = await db.getSpecificJSON(req.body);
  res.status(201).json(ast);
});
//*********************************** */
//**need to update after this line
//*********************************** */

function stringifyFunctions(obj) {
  const result = {};
  for (const key in obj) {
    if (typeof obj[key] === "object") {
      result[key] = stringifyFunctions(obj[key]);
    } else if (typeof obj[key] === "function") {
      result[key] = obj[key].toString();
    } else {
      result[key] = obj[key];
    }
  }
  return result;
}
app.post("/objectRepository/getObjectRepo", (req, res) => {
  const { project_path, project_name } = req.body;

  // Construct the path to the objectRepository.js file
  const objectRepositoryPath = path.join(
    project_path,
    project_name,
    "objectRepository.js"
  );

  // Check if the file exists
  if (fs.existsSync(objectRepositoryPath)) {
    // Delete the file from the cache to ensure we get the latest version
    delete require.cache[require.resolve(objectRepositoryPath)];
    // Require the objectRepository
    const objectRepository = require(objectRepositoryPath);

    // Send the objectRepository back as the response
    res.json(stringifyFunctions(objectRepository));
  } else {
    res.status(400).json({ error: "File not found." });
  }
});
async function addPageToRepository(filePath, pageName) {
  // Read the specified file
  delete require.cache[require.resolve(filePath)];
  const objectRepository = require(filePath);

  // Ensure the specified page object does not already exist
  if (objectRepository[pageName]) {
    throw new Error(
      `Page "${pageName}" already exists in the object repository.`
    );
  }

  // Add the new page object to the objectRepository
  objectRepository[pageName] = {};

  // Replace the content of the file with the updated objectRepository
  let updatedContent = `const objectRepository = ${JSON.stringify(
    objectRepository,
    null,
    2
  )}\nmodule.exports = objectRepository;`.replace(/\\(?=")/g, "");

  // Write the updated content back to the file
  fs.writeFileSync(filePath, updatedContent, "utf8");
}
app.post("/objectRepository/addPage", async (req, res) => {
  try {
    const { filePath, pageName } = req.body;

    // Read the specified file
    const objectRepositoryFileContent = fs.readFileSync(filePath, "utf8");

    // Check if the page already exists
    const pageExists = new RegExp(`"${pageName}"\\s*:\\s*\\{`).test(
      objectRepositoryFileContent
    );
    if (pageExists) {
      throw new Error(`Page "${pageName}" already exists.`);
    }

    // Add the page to the content
    const updatedContent = objectRepositoryFileContent.replace(
      /(const objectRepository = \{)/,
      `$1\n  "${pageName}": {},`
    );

    // Write the updated content back to the file
    fs.writeFileSync(filePath, updatedContent, "utf8");

    res.status(200).json({ message: "Page added successfully." });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Failed to add page.", error: error.message });
  }
});
function functionReviver(key, value) {
  if (typeof value === "string" && value.startsWith("function(")) {
    return new Function("return " + value)();
  }
  return value;
}

app.put("/objectRepository/updateLocator", async (req, res) => {
  const { filePath, pageName, locatorName, locatorValue } = req.body;

  try {
    await updateLocator(filePath, pageName, locatorName, locatorValue);
    res.status(200).json({ message: "Locator updated successfully." });
  } catch (error) {
    res
      .status(400)
      .json({ message: "Failed to update locator.", error: error.message });
  }
});
async function updateLocator(filePath, pageName, locatorName, locatorValue) {
  delete require.cache[require.resolve(filePath)];
  const objectRepository = require(filePath);

  if (!objectRepository[pageName]) {
    throw new Error("Page not found.");
  }

  objectRepository[pageName][locatorName] = locatorValue;

  const objectRepositoryAsString = Object.entries(objectRepository)
    .map(
      ([page, locators]) =>
        `"${page}": {\n${Object.entries(locators)
          .map(([key, value]) => `"${key}": ${value}`)
          .join(",\n")}\n}`
    )
    .join(",\n");

  let updatedContent = `const objectRepository = {\n${objectRepositoryAsString}\n}\nmodule.exports = objectRepository;`;

  fs.writeFileSync(filePath, updatedContent, "utf8");
}

app.post("/objectRepository/renameLocator", async (req, res) => {
  try {
    const { filePath, fileName, pageName, locatorOldName, locatorNewName } =
      req.body;
    const objectRepositoryPath = path.join(filePath, fileName);

    // Read the objectRepository and update the locator
    let objectRepository = require(objectRepositoryPath);

    // Check if the page and locator exist
    if (
      objectRepository[pageName] &&
      objectRepository[pageName][locatorOldName]
    ) {
      // Rename the locator
      objectRepository[pageName][locatorNewName] =
        objectRepository[pageName][locatorOldName];
      delete objectRepository[pageName][locatorOldName];

      // Update the objectRepository file
      let objectRepositoryString = "const objectRepository = {\n";
      for (const pageKey in objectRepository) {
        objectRepositoryString += `  "${pageKey}": {\n`;
        for (const locatorKey in objectRepository[pageKey]) {
          objectRepositoryString += `    "${locatorKey}": ${objectRepository[
            pageKey
          ][locatorKey].toString()},\n`;
        }
        objectRepositoryString += "  },\n";
      }
      objectRepositoryString += "}\nmodule.exports = objectRepository;";

      fs.writeFileSync(objectRepositoryPath, objectRepositoryString, "utf8");

      // Replace the old locator name with the new one in all the files under the tests folder
      const testsFolderPath = path.join(filePath, "tests");
      const testFiles = fs.readdirSync(testsFolderPath);

      testFiles.forEach((testFile) => {
        const testFilePath = path.join(testsFolderPath, testFile);
        let fileContent = fs.readFileSync(testFilePath, "utf8");
        const regex = new RegExp(`\\b${locatorOldName}\\b`, "g");
        fileContent = fileContent.replace(regex, locatorNewName);
        fs.writeFileSync(testFilePath, fileContent, "utf8");
      });

      res.json({ message: "Locator renamed successfully." });
    } else {
      res.status(400).json({
        message: "Failed to rename locator.",
        error: "Locator or page not found.",
      });
    }
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Failed to rename locator.", error: error.message });
  }
});
app.post("/objectRepository/moveLocator", async (req, res) => {
  try {
    const { filePath, fileName, pageName, locatorName, newPageName } = req.body;
    const objectRepositoryPath = path.join(filePath, fileName);

    // Read the objectRepository and update the locator
    let objectRepository = require(objectRepositoryPath);

    // Check if the page and locator exist
    if (objectRepository[pageName] && objectRepository[pageName][locatorName]) {
      // Rename the locator
      objectRepository[newPageName][locatorName] =
        objectRepository[pageName][locatorName];
      delete objectRepository[pageName][locatorName];

      // Update the objectRepository file
      let objectRepositoryString = "const objectRepository = {\n";
      for (const pageKey in objectRepository) {
        objectRepositoryString += `  "${pageKey}": {\n`;
        for (const locatorKey in objectRepository[pageKey]) {
          objectRepositoryString += `    "${locatorKey}": ${objectRepository[
            pageKey
          ][locatorKey].toString()},\n`;
        }
        objectRepositoryString += "  },\n";
      }
      objectRepositoryString += "}\nmodule.exports = objectRepository;";

      fs.writeFileSync(objectRepositoryPath, objectRepositoryString, "utf8");

      // Replace the old locator name with the new one in all the files under the tests folder
      const testsFolderPath = path.join(filePath, "tests");
      const testFiles = fs.readdirSync(testsFolderPath);

      testFiles.forEach((testFile) => {
        const testFilePath = path.join(testsFolderPath, testFile);
        let fileContent = fs.readFileSync(testFilePath, "utf8");
        const oldPattern = `${pageName}.${locatorName}`;
        const newPattern = `${newPageName}.${locatorName}`;
        const regex = new RegExp(`\\b${oldPattern}\\b`, "g");
        fileContent = fileContent.replace(regex, newPattern);
        fs.writeFileSync(testFilePath, fileContent, "utf8");
      });

      res.json({ message: "Locator renamed successfully." });
    } else {
      res.status(400).json({
        message: "Failed to move locator.",
        error: "Locator or page not found.",
      });
    }
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Failed to rename locator.", error: error.message });
  }
});

app.post("/dataRepository/getContent", (req, res) => {
  const filePath = `${req.body.filePath}/dataRepository.json`;

  if (!fs.existsSync(filePath)) {
    return res.status(404).json({ message: "File not found" });
  }

  const content = fs.readFileSync(filePath, "utf-8");
  const parsedContent = JSON.parse(content);

  res.status(200).json(parsedContent);
});

app.post("/dataRepository/updateData", async (req, res) => {
  const path = req.body.path;
  const data = req.body.data;
  console.log(JSON.stringify(req.body.path));
  // Validate the inputs
  if (typeof path !== "string" || typeof data !== "object") {
    res.status(400).send({ error: "Invalid input" });
    return;
  }

  // Write data to file
  try {
    await fs.writeFile(path, JSON.stringify(data, null, 2), (err) => {
      if (err) {
        console.error(err);
        // handle error...
      } else {
        console.log("File written successfully");
        // perform other actions...
      }
    });
    res.status(200).send({ message: "Data successfully written to file" });
  } catch (err) {
    console.error(err);
    res.status(500).send({ error: "Failed to write to file" });
  }
});
app.post("/data/updateDataFiles", (req, res) => {
  const folderPath = req.body.folderPath;
  const oldNewKeys = req.body.oldNewKeys;

  // Check for required parameters
  if (!folderPath || !oldNewKeys) {
    return res.status(400).send("folderPath and oldNewKeys are required.");
  }

  fs.readdir(folderPath, (err, files) => {
    if (err) {
      return res.status(500).send("Error reading directory.");
    }

    files.forEach((file) => {
      const filePath = path.join(folderPath, file);

      fs.readFile(filePath, "utf-8", (err, data) => {
        if (err) {
          return res.status(500).send("Error reading file.");
        }

        let updatedData = data;

        oldNewKeys.forEach((keyMap) => {
          updatedData = updatedData.replace(
            new RegExp(keyMap.oldKey, "g"),
            keyMap.newKey
          );
        });

        fs.writeFile(filePath, updatedData, "utf-8", (err) => {
          if (err) {
            return res.status(500).send("Error writing to file.");
          }
        });
      });
    });

    res.status(200).send("Files updated successfully.");
  });
});

function replaceValuesInFiles(folderPath, valuesToReplace) {
  // Check if the path exists
  if (!fs.existsSync(folderPath)) {
    console.log("The provided path does not exist");
    return;
  }

  // Check if the path is a directory
  if (!fs.lstatSync(folderPath).isDirectory()) {
    console.log("The provided path is not a directory");
    return;
  }

  // Read all files in the directory
  fs.readdirSync(folderPath).forEach((file) => {
    const filePath = path.join(folderPath, file);
    // Check if the path is a file
    if (fs.lstatSync(filePath).isFile()) {
      let fileContent = fs.readFileSync(filePath, "utf-8");

      // Replace the old values with the new values
      for (const [oldValue, newValue] of Object.entries(valuesToReplace)) {
        const regex = new RegExp(oldValue, "g");
        fileContent = fileContent.replace(regex, newValue);
      }

      // Write the new content to the file
      fs.writeFileSync(filePath, fileContent);
    }
  });
}

app.post("/dataRepository/replaceValues", async (req, res) => {
  const dirPath = req.body.path;
  const replacements = req.body.data;

  // Validate the inputs
  if (typeof dirPath !== "string" || typeof replacements !== "object") {
    res.status(400).send({ error: "Invalid input" });
    return;
  }

  try {
    await replaceValuesInFiles(dirPath, replacements);
    res.status(200).send({ message: "Data successfully replaced in files" });
  } catch (err) {
    console.error(err);
    res.status(500).send({ error: "Failed to replace data in files" });
  }
});
app.post("/objectRepository/getObjectsForUser", (req, res) => {
  const filePath = req.body.filePath;
  if (!filePath) {
    return res.status(400).send("File path is required");
  }

  fs.readFile(filePath, "utf8", (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).send(err);
    }

    const objectRepository = requireFromString(data);
    let result = [];

    for (let page in objectRepository) {
      for (let key in objectRepository[page]) {
        result.push(`objectRepository.${page}.${key}`);
      }
    }

    res.json(result);
  });
});

// get documents path
app.get("/documentsPath", (req, res) => {
  const documentsPath = path.join(os.homedir(), "Documents");
  res.send(documentsPath);
});

// read file content
app.post("/readFile", (req, res) => {
  const filePath = req.body.path;

  if (!filePath) {
    return res.status(400).send({ error: "Path is required." });
  }

  fs.readFile(filePath, "utf8", (err, data) => {
    if (err) {
      return res.status(500).send({ error: "Failed to read the file." });
    }
    res.send(data);
  });
});

const executeGitCommand = (cmd, path, callback) => {
  exec(cmd, { cwd: path }, (error, stdout, stderr) => {
    if (error) {
      console.warn(error);
      callback(error, null);
      return;
    }
    callback(null, stdout ? stdout : stderr);
  });
};

app.post("/git/add", (req, res) => {
  const { folderPath } = req.body;
  const cmd = "git add .";
  executeGitCommand(cmd, folderPath, (error, result) => {
    if (error) {
      res.status(500).send({ error: "Failed to add files" });
    } else {
      res.send({ message: "Files added successfully", result });
    }
  });
});

app.post("/git/commit", (req, res) => {
  const { folderPath, commitMessage } = req.body;
  if (!commitMessage) {
    res.status(400).send({ error: "Commit message is required" });
    return;
  }
  const cmd = `git commit -m "${commitMessage}"`;
  executeGitCommand(cmd, folderPath, (error, result) => {
    if (error) {
      res.status(500).send({ error: "Failed to commit files" });
    } else {
      res.send({ message: "Files committed successfully", result });
    }
  });
});

app.post("/git/push", (req, res) => {
  const { folderPath } = req.body;
  const cmd = "git push -u origin master";
  executeGitCommand(cmd, folderPath, (error, result) => {
    if (error) {
      res.status(500).send({ error: "Failed to push files" });
    } else {
      res.send({ message: "Files pushed successfully", result });
    }
  });
});
app.post("/git/status", (req, res) => {
  const { folderPath } = req.body;
  const cmd = "git status";
  executeGitCommand(cmd, folderPath, (error, result) => {
    if (error) {
      res.status(500).send({ error: "Failed to fetch git status" });
    } else {
      res.send({ message: "Git status fetched successfully", result });
    }
  });
});

// generate api script
app.post("/api/generateScript", (req, res) => {
  const tests = req.body;
  const playwrightScript = convertToPlaywright(tests);
  res.type("application/javascript");
  res.send(playwrightScript);
});

function convertToPlaywright(tests) {
  let script = `const { test, expect } = require('@playwright/test');\n\n`;

  for (let key in tests) {
    const testConfig = tests[key];
    if (testConfig.method && testConfig.url) {
      script += generatePlaywrightTest(testConfig, key);
    }
  }

  return script;
}

function generatePlaywrightTest(testConfig, key) {
  const method = testConfig.method.toLowerCase();
  const url = testConfig.url;
  const requestBody = JSON.stringify(testConfig.requestBody || {});
  const headers = JSON.stringify(testConfig.headers || {});
  const statusCode = testConfig.expectedStatusCode;

  let testCode = `test('${method.toUpperCase()} ${url}', async ({ request }) => {\n`;
  testCode += `  const response = await request.${method}('${url}', {\n`;

  if (testConfig.headers) {
    testCode += `    headers: ${headers},\n`;
  }
  if (Object.keys(testConfig.requestBody || {}).length > 0) {
    testCode += `    data: ${requestBody},\n`;
  }

  testCode += `  });\n\n`;

  if (testConfig.isStatusValdiation && statusCode) {
    testCode += `  expect(response.status()).toBe(${statusCode});\n`;
  }

  if (testConfig.isKeyValueValidation && testConfig.expectedKeyValue) {
    for (let [key, value] of Object.entries(testConfig.expectedKeyValue)) {
      testCode += `  expect(await response.json()).toHaveProperty('${key}', '${value}');\n`;
    }
  }

  testCode += `});\n\n`;
  return testCode;
}

app.listen(1337, () => console.log("server running on port 1337"));
