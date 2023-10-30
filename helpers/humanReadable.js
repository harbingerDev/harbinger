const utils = require("./utls");
const locActions = require("../playwrightActionLocators.json");

function getHumanReadable(tokenAray) {
  console.log(JSON.stringify(tokenAray));
  let base = "";
  if (tokenAray.includes("objectRepository") && tokenAray[0] === "const") {
    base = utils.findValueByKeyInArray(
      locActions.gettersAndVerifiers,
      tokenAray
    );
    const index = tokenAray.indexOf("objectRepository");
    base = base.replace(
      "x-locator",
      `${tokenAray[index + 2]} present on ${tokenAray[index + 1]} page`
    );
    base = base.replace("x-value", tokenAray[tokenAray.length - 1]);
    base = base.replace("x-file", tokenAray[tokenAray.length - 1]);
    base = base.replace("x-url", tokenAray[tokenAray.length - 1]);
    base = base.replace("x-keys", tokenAray[tokenAray.length - 1]);
    base = base.replace(
      "dataRepository, process, env, EXECUTION_ENVIRONMENT, ",
      ""
    );
    return base;
  } else if (
    tokenAray.includes("objectRepository") ||
    tokenAray[2] === "goto"
  ) {
    base = utils.findValueByKeyInArray(locActions.actions, tokenAray);
    const index = tokenAray.indexOf("objectRepository");
    base = base.replace(
      "x-locator",
      `${tokenAray[index + 2]} present on ${tokenAray[index + 1]} page`
    );
    base = base.replace("x-value", tokenAray[tokenAray.length - 1]);
    base = base.replace("x-file", tokenAray[tokenAray.length - 1]);
    base = base.replace("x-url", tokenAray[tokenAray.length - 1]);
    base = base.replace("x-keys", tokenAray[tokenAray.length - 1]);
    base = base.replace(
      "dataRepository, process, env, EXECUTION_ENVIRONMENT, ",
      ""
    );
    return base;
  } else {
    if (
      tokenAray.includes('"popup"') &&
      (tokenAray.includes("page1Promise") || tokenAray.includes("pagePromise"))
    ) {
      return "Creating popup/page promise";
    } else if (
      !tokenAray.includes("popup") &&
      (tokenAray.includes("page1Promise") || tokenAray.includes("pagePromise"))
    ) {
      return "Expecting popup/page promise to complete";
    } else if (tokenAray[0] === "expect" && tokenAray[1] === "soft") {
      if (tokenAray.length === 5) {
        return `Soft assert ${tokenAray[2]} ${splitCamelCase(tokenAray[3])} ${
          tokenAray[4]
        }`;
      } else {
        return `Soft assert ${tokenAray[2]} ${splitCamelCase(tokenAray[3])}`;
      }
    } else {
      if (tokenAray.length === 4) {
        return `Assert ${tokenAray[1]} ${splitCamelCase(tokenAray[2])} ${
          tokenAray[3]
        }`;
      } else {
        return `Assert ${tokenAray[1]} ${splitCamelCase(tokenAray[2])}`;
      }
    }
  }
}
function splitCamelCase(str) {
  return str.replace(/([a-z0-9])([A-Z])/g, "$1 $2").toLowerCase();
}

module.exports = {
  getHumanReadable,
};
