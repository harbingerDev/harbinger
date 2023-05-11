const fs = require("fs");

function createEnvFile(path) {
  let data = "";
  const envVars = {
    BASE_URL: "URL_TO_BE_UPDATED",
    EXECUTION_ENVIRONMENT: "qa",
  };
  Object.keys(envVars).forEach((key) => {
    data += `${key}=${envVars[key]}\n`;
  });
  fs.writeFileSync(`${path}/.env`, data);
}

module.exports = { createEnvFile };
