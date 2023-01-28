const { exec } = require("child_process");
const { resolve } = require("path");
const confighelper = require("./configHelper");
const fs = require("fs");
var esprima = require("esprima");

//project functions
async function createProjectOnDisk(req) {
  const configurator = confighelper.getRequiredConfigAndWriteToFile(req);
  const configuratorFileName = "playwright.config.js";
  const configCommand = `echo ${configurator} > ${configuratorFileName}`;
  return new Promise((resolve, reject) => {
    const updatedProjectName = req.project_name.replaceAll(" ", "_");
    exec(
      `mkdir ${req.project_path}\\${updatedProjectName} && cd ${req.project_path}\\${updatedProjectName} && npm init -y && npm i -D @playwright/test && npx playwright install && mkdir tests && ${configCommand}`,
      (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          reject(error);
        }
        console.log(`stdout: ${stdout}`);
        resolve(true);
      }
    );
  });
}

//script functions
async function createScript(req) {
  const temp = "tempScript.spec.js";
  return new Promise((resolve, reject) => {
    exec(
      `npx playwright codegen -o "${req.project_path}\\${req.project_name}\\tests\\${temp}" ${req.url}`,
      (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          reject(error);
        }
        console.log(`stdout: ${stdout}`);
        resolve(true);
      }
    );
  }).then(async () => {
    if (
      await fs.existsSync(
        `${req.project_path}\\${req.project_name}\\tests\\${req.script_name}`
      )
    ) {
      await replaceAndAppend(
        `${req.project_path}\\${req.project_name}\\tests\\${temp}`,
        `${req.project_path}\\${req.project_name}\\tests\\${req.script_name}`,
        "'test', async",
        `'${req.test_name} ${req.tags}', async`,
        "import { test, expect } from '@playwright/test';"
      );
    } else {
      await replaceAndRename(
        `${req.project_path}\\${req.project_name}\\tests\\${temp}`,
        `${req.project_path}\\${req.project_name}\\tests\\${req.script_name}`,
        "'test', async",
        `'${req.test_name} ${req.tags}', async`
      );
    }
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
  return new Promise((resolve, reject) => {
    fs.readdir(
      `${req.project_path}\\${req.project_name}\\tests`,
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
  return new Promise((resolve, reject) => {
    exec(
      `cd ${req.project_path}\\${req.project_name} && npx playwright test tests/${req.script_name} --headed`,
      (error, stdout, stderr) => {
        console.log(`stdout: ${stdout}`);
        resolve(true);
      }
    );
  });
}
async function executeScripts(req) {
  return new Promise((resolve, reject) => {
    exec(
      `cd ${req.project_path}\\${req.project_name} && npx playwright test --headed`,
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

// AST specific
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
};
