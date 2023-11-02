const fs = require("fs");
const prettier = require("prettier");

function replaceAsyncPage(filePath) {
  // Read the contents of the file
  const fileContents = fs.readFileSync(filePath, "utf8");
  let addedObjectRequire = fileContents.replace(
    'import { test, expect } from "@playwright/test";',
    'import { test, expect, request } from "@playwright/test";\nconst objectRepository = require("../objectRepository")\nconst dataRepository = require("../dataRepository.json")\nrequire("dotenv").config()'
  );
  // Replace all occurrences of async ({ page }) with async ({ page, context })
  const replacedContents = addedObjectRequire.replace(
    "async ({ page })",
    "async ({ page, context })"
  );

  // Write the updated contents to the file
  fs.writeFileSync(filePath, replacedContents, "utf8");
}
function replacePatternInFile(filePath) {
  return new Promise((resolve, reject) => {
    // read the file
    fs.readFile(filePath, "utf8", function (err, data) {
      if (err) {
        reject(err);
        return;
      }

      // match the pattern and replace it

      const pattern =
        /const \[(\w+)\] = await Promise\.all\(\[\n\s+(.+),\n\s+((?:page\.locator\([^)]*\)|page)[\s\S]+?)\]\);/;

      // /const \[(\w+)\] = await Promise\.all\(\[\s*([^,]+),[\s\S]*?([^,]+)\s*\]\);/;
      let match;
      let i = 1;
      while ((match = pattern.exec(data)) !== null) {
        const [, pageName, statement1, statement2] = match;
        const replacement = `const page${i}Promise = context.waitForEvent('page');\nawait ${statement2};\nconst ${pageName} = await page${i}Promise;\nawait ${pageName}.waitForLoadState();`;
        data = data.replace(match[0], replacement);
        i++;
      }

      // format the modified file with Prettier
      const formattedData = prettier.format(data, {
        parser: "babel",
        printWidth: 1000,
      });
      // save the modified and formatted file
      fs.writeFile(filePath, formattedData, "utf8", function (err) {
        if (err) {
          reject(err);
          return;
        }
        resolve();
      });
    });
  });
}

module.exports = { replacePatternInFile, replaceAsyncPage };
