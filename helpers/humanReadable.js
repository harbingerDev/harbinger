const utils = require("./utls");
const locActions = require("../playwrightActionLocators.json");

function getHumanReadable(tokenAray) {
  let base = "";
  if (tokenAray.includes("objectRepository")) {
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
    base = utils.findValueByKeyInArray(locActions.actions, tokenAray);
    let index = utils.findLastIndexOfValue(tokenAray, locActions.locators);
    base = base.replace("x-locator", tokenAray[index + 1]);
    base = base.replace("x-value", tokenAray[tokenAray.length - 1]);
    base = base.replace("x-file", tokenAray[tokenAray.length - 1]);
    base = base.replace("x-url", tokenAray[tokenAray.length - 1]);
    base = base.replace("x-keys", tokenAray[tokenAray.length - 1]);

    return base;
  }
}

module.exports = {
  getHumanReadable,
};
