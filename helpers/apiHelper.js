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

function getSecuritySchema(schemaName) {
    schemaName=Object.keys(schemaName)[0]
    
    const jsonFilePath = "test.json";
    const data = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));
    const securitySchemas = data.components.securitySchemes || {};
    console.log("ss",securitySchemas)
    console.log("schemaName",schemaName,"inside","type",securitySchemas[schemaName]?.type,securitySchemas[schemaName]?.name)
    const tokenname=securitySchemas[schemaName]?.name
   
    
    return {[tokenname]:"Bearer token"};
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



async function getApiInfo(apiInfo, method)  {
    console.log("apiInfo",apiInfo,"method",method)
    const pathvariable = [];
    const queryparam = [];
    const reqbody = [];
    const responseschema = [];
    let securityparameters = {};
    const jsonFilePath = "test.json";
    const data = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));

    try {
        const paths = data.paths[apiInfo] || {};

        // Request Body
        const schemaPath = paths[method]?.requestBody?.content?.["application/json"]?.schema?.$ref;
        if (schemaPath) {
            const match = schemaPath.match(/\/([^/]+)$/);
            if (match) {
                const extractedText = match[1];
                reqbody.push(...getSchema(extractedText));
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
        console.log("Security Parameters",securityParameter,securityParameter.type);
        if (securityParameter.length > 0) {
            console.log("1")
            securityparameters= getSecuritySchema(securityParameter[0]);
            console.log("secur", securityparameters);
            console.log("2")

        }

        console.log("reqbody",reqbody)
        console.log("pathvariable",pathvariable)
        console.log("queryparam",queryparam)
        console.log("securityparameters",securityparameters)
        console.log("responseschema",responseschema)
        

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
let uniqueIdentifierCounter = 0;

function getUniqueIdentifier() {
    uniqueIdentifierCounter += 1;
    return uniqueIdentifierCounter;
}

  

module.exports = {
    getApiInfo,
    getAllDataAndParse,
    convertToPlaywright
  };
  