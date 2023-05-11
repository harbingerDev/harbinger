const fs = require("fs");

function createDataRepositoryFile(path) {
  const data = {
    dev: {},
    qa: {},
    integration: {},
    staging: {},
    uat: {},
    prod: {},
  };

  fs.writeFileSync(`${path}/dataRepository.json`, JSON.stringify(data), "utf8");
}

async function updateDataRepositoryFile(filePath, dataRepoPath) {
  const dataRepo = JSON.parse(fs.readFileSync(dataRepoPath, "utf8"));

  // Read the test script file line by line
  const lines = fs.readFileSync(filePath, "utf8").split("\n");

  let updatedLines = [];

  lines.forEach((line) => {
    const match = line.match(
      /(objectRepository\..*?)\.(fill|select|selectOption)\(["'](.+?)["']\)/
    );
    if (match) {
      const key = `data_${Math.floor(Math.random() * 1000000)}`;
      for (const environmentKey in dataRepo) {
        dataRepo[environmentKey][key] = match[3];
      }

      const updatedLine = line.replace(
        `"${match[3]}"`,
        `dataRepository[process.env.EXECUTION_ENVIRONMENT].${key}`
      );
      updatedLines.push(updatedLine);
    } else {
      updatedLines.push(line);
    }
  });

  // Write the updated test script file
  fs.writeFileSync(filePath, updatedLines.join("\n"));

  // Write the updated data repository file
  fs.writeFileSync(dataRepoPath, JSON.stringify(dataRepo, null, 2));
}

module.exports = { createDataRepositoryFile, updateDataRepositoryFile };
