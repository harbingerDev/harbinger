const { exec } = require("child_process");
const fs = require("fs-extra");
const { resolve } = require("path");
const path = require("path");
const confighelper = require("./configHelper");
var esprima = require("esprima");
const astring = require("astring");
const humanReadable = require("./humanReadable");
const objectRepo = require("./objectRepoHelper");
const promiseHandler = require("./promiseHelper");
const dataRepo = require("./dataRepoHelper");
const envHelper = require("./environmentHelper");
const os = require("os");
const { Console } = require("console");

//project functions
async function createProjectOnDisk(req) {
  try {
    // Setup paths and filenames
    const separator = path.sep; // Use Node.js's path module to get the OS-specific separator
    const updatedProjectName = req.project_name.replaceAll(" ", "_");
    const projectDir = path.join(req.project_path, updatedProjectName);
    const configuratorFileName = path.join(projectDir, "playwright.config.js");

    // Get configurator content
    const configurator = confighelper.getRequiredConfigAndWriteToFile(req);

    // Create directory and setup project
    await fs.ensureDir(path.join(projectDir, "tests")); // This also creates the parent directories if they don't exist
    process.chdir(projectDir); // Change to project directory

    await new Promise((resolve, reject) => {
      // Initialize npm and install packages
      exec(
        "npm init -y && npm i -D @playwright/test @reportportal/agent-js-playwright dotenv && npx playwright install && git init && git remote add origin git@github.com:codetesta2z/kilimanjaro.git",
        (error, stdout) => {
          if (error) {
            console.error(`exec error: ${error}`);
            return reject(error);
          }
          console.log(`stdout: ${stdout}`);
          resolve();
        }
      );
    });

    // Write the configuration to the file
    fs.writeFileSync(configuratorFileName, configurator);

    // Create additional files
    createGitignore(projectDir);
    objectRepo.createObjectRepositoryFile(projectDir);
    dataRepo.createDataRepositoryFile(projectDir);
    envHelper.createEnvFile(projectDir);

    return true;
  } catch (error) {
    console.error(`Error in createProjectOnDisk: ${error}`);
    throw error;
  }
}
function createGitignore(folderName) {
  const content = `
node_modules/
/test-results/
/playwright-report/
/playwright/.cache/
`;

  const gitignorePath = path.join(folderName, ".gitignore");

  fs.writeFile(gitignorePath, content.trim(), (err) => {
    if (err) {
      console.error("Error writing .gitignore file:", err);
    } else {
      console.log(".gitignore file has been created successfully!");
    }
  });
}

//script functions
async function createScript(req) {
  const separator = os.platform() === "win32" ? "\\" : "/";
  const temp = "tempScript.spec.js";
  return new Promise((resolve, reject) => {
    exec(
      `npx playwright codegen -o "${req.project_path}${separator}${req.project_name}${separator}tests${separator}${temp}" ${req.url}`,
      (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          reject(error);
        }
        console.log(`stdout: ${stdout}`);
        resolve(true);
      }
    );
  })
    .then(async () => {
      if (
        await fs.existsSync(
          `${req.project_path}${separator}${req.project_name}${separator}tests${separator}${req.script_name}`
        )
      ) {
        await replaceAndAppend(
          `${req.project_path}${separator}${req.project_name}${separator}tests${separator}${temp}`,
          `${req.project_path}${separator}${req.project_name}${separator}tests${separator}${req.script_name}`,
          "'test', async",
          `'${req.test_name} ${req.tags}', async`,
          "import { test, expect } from '@playwright/test';"
        );
      } else {
        await replaceAndRename(
          `${req.project_path}${separator}${req.project_name}${separator}tests${separator}${temp}`,
          `${req.project_path}${separator}${req.project_name}${separator}tests${separator}${req.script_name}`,
          "'test', async",
          `'${req.test_name} ${req.tags}', async`
        );

        await promiseHandler
          .replacePatternInFile(
            `${req.project_path}${separator}${req.project_name}${separator}tests${separator}${req.script_name}`
          )
          .then(async () => {
            console.log("File modified and saved successfully!");
            await promiseHandler.replaceAsyncPage(
              `${req.project_path}${separator}${req.project_name}${separator}tests${separator}${req.script_name}`
            );
          })
          .catch((err) => {
            console.error("Error modifying file:", err);
          });
      }
    })
    .then(async () => {
      const godJSON = await getGodJSONInternal(
        `${req.project_path}${separator}${req.project_name}${separator}tests${separator}${req.script_name}`
      );
      await objectRepo.getControlsFromGodJSON(
        godJSON,
        `${req.project_path}${separator}${req.project_name}${separator}objectRepository.js`,
        `${req.project_path}${separator}${req.project_name}${separator}tests${separator}${req.script_name}`,
        `${req.project_path}${separator}${req.project_name}${separator}dataRepository.json`
      );
    });
}

async function replaceAndAppend(
  oldFileName,
  NewFileName,
  testNameToBeReplaced,
  testNameToReplace,
  importString
) {
  try {
    let data = await fs.promises.readFile(oldFileName, "utf8");
    let newData = data
      .replace(testNameToBeReplaced, testNameToReplace)
      .replace(importString, "");
    await fs.promises.appendFile(NewFileName, newData);
    console.log("The file has been appended!");
    await fs.promises.unlink(oldFileName);
  } catch (err) {
    console.log(err);
  }
}

async function replaceAndRename(
  oldFileName,
  NewFileName,
  stringToBeReplaced,
  stringToReplace
) {
  try {
    let data = await fs.promises.readFile(oldFileName, "utf8");
    let newData = data.replace(stringToBeReplaced, stringToReplace);
    await fs.promises.writeFile(oldFileName, newData, "utf8");
    console.log("The file has been saved!");
    await fs.promises.rename(oldFileName, NewFileName);
    console.log("File Renamed!");
  } catch (err) {
    console.log(err);
  }
}

async function getScripts(req) {
  const separator = os.platform() === "win32" ? "\\" : "/";
  return new Promise((resolve, reject) => {
    fs.readdir(
      `${req.project_path}${separator}${req.project_name}${separator}tests`,
      (err, fileNames) => {
        if (err) {
          reject(err);
          return;
        }
        resolve(fileNames);
      }
    );
  });
}

//execution functions
async function executeScript(req) {
  const separator = os.platform() === "win32" ? "\\" : "/";
  return new Promise((resolve, reject) => {
    exec(
      `cd ${req.project_path}${separator}${req.project_name} && npx playwright test tests/${req.script_name} --headed`,
      (error, stdout, stderr) => {
        console.log(`stdout: ${stdout}`);
        resolve(true);
      }
    );
  });
}
async function executeScripts(req) {
  const separator = os.platform() === "win32" ? "\\" : "/";
  return new Promise((resolve, reject) => {
    exec(
      `cd ${req.project_path}${separator}${req.project_name} && npx playwright test --headed`,
      (error, stdout, stderr) => {
        console.log(`stdout: ${stdout}`);
        resolve(true);
      }
    );
  });
}

//everything related to system
async function checkNodeVersion() {
  return new Promise((resolve, reject) => {
    try {
      exec(`node --version`, (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          reject("not installed");
        }
        console.log(`stdout: ${stdout}`);
        resolve(stdout);
      });
    } catch (error) {
      reject("not installed");
    }
  });
}

async function checkGitVersion() {
  return new Promise((resolve, reject) => {
    try {
      exec(`git --version`, (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          reject("not installed");
        }
        console.log(`stdout: ${stdout}`);
        resolve(stdout);
      });
    } catch (error) {
      reject("not installed");
    }
  });
}

// *** AST specific

function extractValuesFromAst(node) {
  const values = [];

  function traverse(node, parentNode = null) {
    if (!node) return;

    if (node.type === "ExpressionStatement") {
      traverse(node.expression, node);
    } else if (node.type === "VariableDeclaration") {
      values.push(node.kind);
      node.declarations.forEach((decl) => traverse(decl, node));
    } else if (node.type === "VariableDeclarator") {
      traverse(node.id, node);
      traverse(node.init, node);
    } else if (node.type === "AwaitExpression") {
      values.push("await");
      traverse(node.argument, node);
    } else if (node.type === "Identifier") {
      values.push(node.name);
    } else if (node.type === "Literal") {
      console.log("value", node.value);
      values.push(
        JSON.stringify(
          node.value.replace(/\[id="\\\\([0-9])([^\]]+)\]/g, (match, p1) => p1)
        )
      );
    } else if (node.type === "CallExpression") {
      traverse(node.callee, node);

      const argsValues = node.arguments
        .map((arg) => extractValuesFromAst(arg))
        .flat();
      if (argsValues.length > 0) {
        if (parentNode && parentNode.type === "CallExpression") {
          values.push(...argsValues);
        } else {
          values.push(argsValues.join(", "));
        }
      }
    } else if (node.type === "MemberExpression") {
      traverse(node.object, node);
      traverse(node.property, node);
    } else if (node.type === "ObjectExpression") {
      const properties = node.properties
        .map((prop) => {
          return `${prop.key.name}: ${JSON.stringify(prop.value.value)}`;
        })
        .join(", ");
      values.push(`{ ${properties} }`);
    }
  }

  traverse(node);
  return values;
}

function getPreTestBlock(astBody) {
  let preTestBlockArray = [];
  astBody.forEach((block, index) => {
    let requiredObject = {};
    if (block.type === "ImportDeclaration") {
      requiredObject["type"] = "ImportDeclaration";
      requiredObject["statement"] = astring.generate(block);
    } else if (block.type === "VariableDeclaration") {
      requiredObject["type"] = "VariableDeclaration";
      requiredObject["statement"] = astring.generate(block);
    }
    if (Object.keys(requiredObject).length !== 0) {
      preTestBlockArray.push(requiredObject);
    }
  });

  return preTestBlockArray;
}

function getTestBlocks(astBody) {
  let testBlockArray = [];
  astBody.forEach((block, index) => {
    let requiredObject = {};
    if (block.type === "ExpressionStatement") {
      if (block.expression.hasOwnProperty("callee")) {
        if (block.expression.callee.name === "test") {
          requiredObject["type"] = "test";
          const regex = /@?[\w\s]+/g;
          const matches = block.expression.arguments[0].value.match(regex);
          requiredObject["testName"] = matches[0];
          requiredObject["testTags"] = matches.slice(1);
          requiredObject["testStepsArray"] = getTestStepsBlocks(
            block.expression.arguments[1].body.body
          );
        }
      }
    }
    if (Object.keys(requiredObject).length !== 0) {
      testBlockArray.push(requiredObject);
    }
  });
  return testBlockArray;
}
function getTestStepsBlocks(astBody) {
  let testStepsArray = [];
  astBody.forEach((block, index) => {
    let requiredObject = {};
    requiredObject["statement"] = astring.generate(block);
    requiredObject["tokens"] = extractValuesFromAst(block);
    requiredObject["humanReadableStatement"] = humanReadable.getHumanReadable(
      requiredObject["tokens"]
    );
    testStepsArray.push(requiredObject);
  });
  return testStepsArray;
}

async function getGodJSON(req) {
  const file = fs.readFileSync(req.path, "utf-8");
  const ast = esprima.parseModule(file, { loc: true });
  let godJSON = {};
  godJSON["preTestBlock"] = getPreTestBlock(ast.body);
  godJSON["testBlockArray"] = getTestBlocks(ast.body);
  return godJSON;
}
function extractExpectSpecicValuesFromAst(ast) {
  const values = [];

  function traverse(node, parentNode = null) {
    if (!node) return;

    if (node.type === "ExpressionStatement") {
      traverse(node.expression, node);
    } else if (node.type === "VariableDeclaration") {
      node.declarations.forEach((decl) => traverse(decl, node));
    } else if (node.type === "VariableDeclarator") {
      traverse(node.id, node);
      traverse(node.init, node);
    } else if (node.type === "Identifier") {
      values.push(node.name);
    } else if (node.type === "Literal") {
      values.push(JSON.stringify(node.value));
    } else if (node.type === "CallExpression") {
      traverse(node.callee, node);
      node.arguments.forEach((arg) => traverse(arg, node));
    } else if (node.type === "MemberExpression") {
      traverse(node.object, node);
      traverse(node.property, node);
    }
  }

  traverse(ast[0]);
  return values;
}

function extracSpecicValuesFromAstActionAndExtract(ast) {
  const values = [];

  function traverse(node) {
    if (!node) return;

    if (node.type === "CallExpression") {
      traverse(node.callee);
      node.arguments.forEach(traverse);
    } else if (node.type === "MemberExpression") {
      traverse(node.object);
      traverse(node.property);
    } else if (node.type === "Identifier") {
      values.push(node.name);
    } else if (node.type === "Literal") {
      values.push(JSON.stringify(node.value));
    }
  }

  if (ast.length > 0) {
    ast.forEach((statement) => {
      if (statement.type === "ExpressionStatement") {
        traverse(statement.expression);
      } else if (statement.type === "VariableDeclaration") {
        statement.declarations.forEach((declaration) => traverse(declaration));
      }
    });
  }
  return values;
}
function extracSpecicValuesFromAstDeclaration(ast) {
  const values = [];

  function traverse(node) {
    if (!node) return;

    if (node.type === "CallExpression") {
      traverse(node.callee);
      node.arguments.forEach(traverse);
    } else if (node.type === "MemberExpression") {
      traverse(node.object);
      traverse(node.property);
    } else if (node.type === "Identifier") {
      values.push(node.name);
    } else if (node.type === "Literal") {
      values.push(JSON.stringify(node.value));
    }
  }

  if (ast.length > 0) {
    ast.forEach((declaration) => {
      if (declaration.type === "VariableDeclaration") {
        values.push(declaration.kind);
        declaration.declarations.forEach((declarator) => {
          traverse(declarator.id);
          traverse(declarator.init);
        });
      }
    });
  }
  return values;
}

async function getSpecificAstJSON(req) {
  const ast = esprima.parseScript(req.statement, { loc: true });
  let requiredObject = {};
  requiredObject["statement"] = req.statement;

  if (req.statement.startsWith("expect")) {
    const result = extractExpectSpecicValuesFromAst(ast.body);
    requiredObject["tokens"] = result;
  } else if (req.statement.startsWith("const")) {
    const result = extracSpecicValuesFromAstDeclaration(ast.body);
    result.splice(2, 0, "await");
    requiredObject["tokens"] = result;
  } else {
    const result = extracSpecicValuesFromAstActionAndExtract(ast.body);
    result.splice(0, 0, "await");
    requiredObject["tokens"] = result;
  }

  requiredObject["humanReadableStatement"] = humanReadable.getHumanReadable(
    requiredObject["tokens"]
  );

  return requiredObject;
}
async function getGodJSONInternal(filePath) {
  const file = fs.readFileSync(filePath, "utf-8");
  const ast = esprima.parseModule(file, { loc: true });
  let godJSON = {};
  godJSON["preTestBlock"] = getPreTestBlock(ast.body);
  godJSON["testBlockArray"] = getTestBlocks(ast.body);
  return godJSON;
}

//*** AST previous functions
async function getASTFromFile(req) {
  const file = fs.readFileSync(req.path, "utf-8");
  let requiredOutput = [];
  const ast = esprima.parseModule(file, { loc: true });
  ast.body.forEach((val, index) => {
    if (val.type === "ExpressionStatement") {
      if (val.expression.callee.name === "test") {
        let requiredObject = {};
        let tagsArray = [];
        requiredObject["name"] =
          val.expression.arguments[0].value.split("@")[0];
        requiredObject.tags = val.expression.arguments[0].value
          .split("@")
          .forEach((val, index) => {
            if (!index == 0) {
              tagsArray.push(`@${val.replace(",", "")}`);
            }
          });
        let statementArray = [];
        val.expression.arguments[1].body.body.forEach((statementVal) => {
          let statementObject = {};
          statementObject.type = statementVal.expression.type;
          statementObject.start = statementVal.loc.start.line;
          statementObject.end = statementVal.loc.end.line;
          statementArray.push(statementObject);
        });
        requiredObject.statements = statementArray;
        requiredObject.start = val.loc.start.line;
        requiredObject.end = val.loc.end.line;
        requiredObject.tags = tagsArray;
        requiredOutput.push(requiredObject);
      }
    }
  });
  return requiredOutput;
}

module.exports = {
  createProjectOnDisk,
  createScript,
  executeScript,
  checkNodeVersion,
  checkGitVersion,
  getScripts,
  executeScripts,
  getASTFromFile,
  getGodJSON,
  getSpecificAstJSON,
};
