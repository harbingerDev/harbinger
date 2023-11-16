const fs = require('fs');
const path = require('path');

function extractPaths(data) {
    const paths = [];

    function findPaths(obj, currentPath = "") {
        if (typeof obj === 'object' && obj !== null) {
            for (const [key, value] of Object.entries(obj)) {
                findPaths(value, `${currentPath}/${key}`);
            }
        } else if (Array.isArray(obj)) {
            obj.forEach((element, index) => {
                findPaths(element, `${currentPath}[${index}]`);
            });
        } else {
            paths.push(currentPath);
        }
    }

    findPaths(data);
    return paths;
}

function getAllDataAndParse(data) {
    const paths = data.paths || {};
    for (const path in paths) {
        console.log(path);
    }
}

function getSchemas() {
    const jsonFilePath = "test.json";
    const jsonData = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));

    try {
        const schemas = jsonData.components.schemas || [];
        const schemaList = Object.keys(schemas);

        const schemasDict = {};
        for (const schema of schemaList) {
            const required = jsonData.components.schemas[schema].required || [];
            const schemaValues = jsonData.components.schemas[schema].properties || {};
            const tupleList = [];

            for (const [key, val] of Object.entries(schemaValues)) {
                const innerDict = {
                    name: key,
                    type: val.type,
                    placeholder: val.title,
                    required: required.includes(key),
                };
                tupleList.push(innerDict);
            }

            schemasDict[schema] = tupleList;
        }

        return schemasDict;
    } catch (error) {
        return { error: "Invalid JSON format" };
    }
}

function getSecuritySchemas(schemaName) {
    const jsonFilePath = "test.json";
    const data = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));
    const securitySchemas = data.components.securitySchemes || {};
    return securitySchemas[schemaName]?.type;
}

function getSecuritySchema(schemaName) {
    const schemasDict = getSecuritySchemas(schemaName);
    // Additional logic needed based on your requirements
}

function getSchema(schemaName) {
    const schemasDict = getSchemas();
    return schemasDict[schemaName];
}

function getAllDataAndParse(data) {
    try {
        const jsonData = JSON.parse(data);
        const paths = jsonData.paths || [];
        const pathList = [];

        for (const [path, methods] of Object.entries(jsonData.paths)) {
            for (const http_method in methods) {
                pathList.push({ path, http_method });
            }
        }

        return pathList;
    } catch (error) {
        return { error: "Invalid JSON format" };
    }
}



function getApiInfo(apiInfo, method) {
    console.log("apiInfo",apiInfo,"method",method)
    const pathvariable = [];
    const queryparam = [];
    const reqbody = [];
    const responseschema = [];
    const securityparameters = {};
    const jsonFilePath = "test.json";
    const data = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));

    try {
        const paths = data.paths[apiInfo] || {};
        console.log("paths",paths)

        // Request Body
        const schemaPath = paths[method]?.requestBody?.content?.["application/json"]?.schema?.$ref;
        console.log("schemaPath",schemaPath)
        if (schemaPath) {
            const match = schemaPath.match(/\/([^/]+)$/);
            console.log("match",match)
            if (match) {
                const extractedText = match[1];
                reqbody.push(...getSchema(extractedText));
                console.log("reqbody",reqbody)
            } else {
                console.log("No match found");
            }
        }

        // Response Schema
        const responseSchemaPath = paths[method]?.responses?.["200"]?.content?.["application/json"]?.schema?.$ref;
        if (responseSchemaPath) {
            const match = responseSchemaPath.match(/\/([^/]+)$/);
            if (match) {
                const extractedText = match[1];
                responseschema.push(...getSchema(extractedText));
            } else {
                console.log("No match found");
            }
        }

        // Path Variables or Query Parameters
        const pathVariableParameters = paths[method]?.parameters || [];
        for (const pathVar of pathVariableParameters) {
            const name = pathVar.name;
            const required = pathVar.required;
            const pathOrReq = pathVar.in;
            const type = pathVar.schema?.type;
            const placeholder = pathVar.schema?.title;
            const onePathVariable = { name, required, type, placeholder };
            if (pathOrReq === "query") queryparam.push(onePathVariable);
            if (pathOrReq === "path") pathvariable.push(onePathVariable);
        }

        // Security Parameters
        const securityParameter = paths[method]?.security || [];
        if (securityParameter.length > 0) {
            securityparameters.type = getSecuritySchema(securityParameter[0]);
            console.log("type", securityparameters.type);
        }

        return {
            reqbody,
            pathvariable,
            queryparam,
            securityparameters,
            responseschema,
        };
    } catch (error) {
        return { error: "Invalid JSON format" };
    }
}



function convertToPlaywright(tests) {
    let script = `const { test, expect } = require('@playwright/test');\n\n`;
  
    script += `test('Combined Test', async ({ request }) => {\n`;
  
    for (let key in tests) {
      const testConfig = tests[key];
      if (testConfig.method && testConfig.url) {
        script += generateTestSteps(testConfig);
      }
    }
  
    script += `});\n\n`;
  
    return script;
  }
  
//   function generateTestSteps(testConfig) {
//     const method = testConfig.method.toLowerCase();
//     const url = testConfig.url;
//     const requestBody = JSON.stringify(testConfig.requestBody || {});
//     const headers = JSON.stringify(testConfig.headers || {});
//     const statusCode = testConfig.expectedStatusCode;
  
//     let testSteps = `  // ${method.toUpperCase()} ${url}\n`;
//     testSteps += `  const response = await request.${method}('${url}', {\n`;
  
//     if (testConfig.headers) {
//       testSteps += `    headers: ${headers},\n`;
//     }
//     if (Object.keys(testConfig.requestBody || {}).length > 0) {
//       testSteps += `    data: ${requestBody},\n`;
//     }
  
//     testSteps += `  });\n\n`;
  
//     if (testConfig.isStatusValidation && statusCode) {
//       testSteps += `  expect(response.status()).toBe(${statusCode});\n`;
//     }
  
//     if (testConfig.isKeyValueValidation && testConfig.expectedKeyValue) {
//       for (let [key, value] of Object.entries(testConfig.expectedKeyValue)) {
//         testSteps += `  expect(await response.json()).toHaveProperty('${key}', '${value}');\n`;
//       }
//     }
  
//     return testSteps;
//   }
function generateTestSteps(testConfig) {
    const method = testConfig.method.toLowerCase();
    const url = testConfig.url;
    const requestBody = testConfig.requestBody || {};
    const headers = testConfig.headers || {};
    const statusCode = testConfig.expectedStatusCode;
  
    let testSteps = `  // ${method.toUpperCase()} ${url}\n`;
    testSteps += `  const response${getUniqueIdentifier()} = await request.${method}('${url}', {\n`;
  
    if (testConfig.headers) {
      testSteps += `    headers: ${headers},\n`;
    }
    if (Object.keys(requestBody).length > 0) {
        const cleanedRequestBody = requestBody.replace(/\\n/g, '').replace(/\\"/g, '"');
      testSteps += `    data: ${cleanedRequestBody},\n`;
    }
  
    testSteps += `  });\n\n`;
  
    if (testConfig.isStatusValidation && statusCode) {
      testSteps += `  expect(response${getUniqueIdentifier()}.status()).toBe(${statusCode});\n`;
    }
  
    if (testConfig.isKeyValueValidation && testConfig.expectedKeyValue) {
      for (let [key, value] of Object.entries(testConfig.expectedKeyValue)) {
        testSteps += `  expect(await response${getUniqueIdentifier()}.json()).toHaveProperty('${key}', '${value}');\n`;
      }
    }
  
    return testSteps;
}

// Function to generate a unique identifier for variable names
function getUniqueIdentifier() {
    return Math.floor(Math.random() * 1000);
}

  

module.exports = {
    getApiInfo,
    getAllDataAndParse,
    convertToPlaywright
  };
  