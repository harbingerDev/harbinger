function findValueByKeyInArray(jsonObj, keysArray) {
  if (keysArray[0] === "const" && keysArray[1] === "pagePromise") {
    return "Promise to return new page";
  } else if (
    keysArray[0] === "const" &&
    keysArray[keysArray.length - 1] === "pagePromise"
  ) {
    return "Opening new page";
  } else if (
    keysArray[0] === "await" &&
    keysArray[keysArray.length - 1] === "waitForLoadState"
  ) {
    return "Waiting for new page to load completely";
  } else {
    for (const key of keysArray) {
      if (jsonObj.hasOwnProperty(key)) {
        return jsonObj[key];
      }
    }
  }
  return null;
}

function findLastIndexOfValue(array, locators) {
  let lastIndex = -1;

  for (let i = array.length - 1; i >= 0; i--) {
    if (locators.includes(array[i])) {
      lastIndex = i;
      break;
    }
  }

  return lastIndex;
}

module.exports = {
  findValueByKeyInArray,
  findLastIndexOfValue,
};
