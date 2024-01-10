const { Console } = require('console');
const fs = require('fs');
const path = require('path');
const js = require('json-schema-generator');
const { JsonSchema } = require('jsonschema');

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
                
                if(val.format){
                    console.log("hi i am inside ",innerDict.type)
                    innerDict.type=val.format
                }
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
    let extrasecurityparameters = [];
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
         const responseSchemaPath2=paths[method]?.responses?.["200"]?.content?.["application/json"]?.schema?.items?.$ref;
         const responseSchemaPath3 = paths[method]?.responses?.["201"]?.content?.["application/json"]?.schema?.$ref;
         const responseSchemaPath4=paths[method]?.responses?.["201"]?.content?.["application/json"]?.schema?.items?.$ref;
         if (responseSchemaPath) {
             const match = responseSchemaPath.match(/\/([^/]+)$/);
             if (match) {
                 const extractedText = match[1];
                 responseschema.push(...getSchema(extractedText));
             } else {
                 console.log("No match found");
             }
         }
         else if  (responseSchemaPath2) {
             const match = responseSchemaPath2.match(/\/([^/]+)$/);
             if (match) {
                 const extractedText = match[1];
                 responseschema.push(...getSchema(extractedText));
             } else {
                 console.log("No match found");
             }
         }
         else if  (responseSchemaPath3) {
             const match = responseSchemaPath3.match(/\/([^/]+)$/);
             if (match) {
                 const extractedText = match[1];
                 responseschema.push(...getSchema(extractedText));
             } else {
                 console.log("No match found");
             }
         }
         else if  (responseSchemaPath4) {
             const match = responseSchemaPath4.match(/\/([^/]+)$/);
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
            // if (pathOrReq === "header")securityparameters=onePathVariable
            if (pathOrReq === "header")extrasecurityparameters.push(onePathVariable);
            
            console.log(securityparameters)
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
            extrasecurityparameters
        };
    } catch (error) {
        return { error: "Invalid JSON format" };
    }
}


function generateOAuthSteps(oauthCredentials) {
    let { clientId, clientSecret, tokenEndpoint, variable } = JSON.parse(oauthCredentials);
    // console.log(jsonInput["clientId"],"}]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]")
    tokenEndpoint=tokenEndpoint.trim()
    let oAuthSteps = `  // OAuth 2.0 Authorization\n`;
    oAuthSteps += `  const tokenResponse = await request.post('${tokenEndpoint}', {\n`;
    oAuthSteps += `    data: \`grant_type=client_credentials&client_id=${clientId}&client_secret=${clientSecret}\`,\n`;
    oAuthSteps += `    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },\n`;
    oAuthSteps += `  });\n\n`;
    oAuthSteps+=  `   const tokenjsonResponse = await tokenResponse.json();  `
    oAuthSteps += `  const ${variable} = tokenjsonResponse.access_token;\n\n`;
    return oAuthSteps;
  }

function convertToPlaywright(tests,isUsingOAuth,oauthCredentials) {
    let script = `const { test, expect } = require('@playwright/test');\n import { faker } from '@faker-js/faker';\n const Ajv = require('ajv');\n const ajv = new Ajv(); \n\n`;
    
  
    script += `test('Harbinger Test', async ({ request }) => {\n`;

   if(isUsingOAuth) script += generateOAuthSteps(oauthCredentials);
    for (let key in tests) {
      const testConfig = tests[key];
      if (testConfig.method && testConfig.url) {
        script += generateTestSteps(testConfig);
      }
    }
  
    script += `});\n\n`;
  
    return script;
  }

// function generateTestSteps(testConfig) {
//     const method = testConfig.method.toLowerCase();
//     const url = testConfig.url;
//     const requestBody =  JSON.parse(testConfig.requestBody) || [];
//     console.log("reqqq",requestBody)
//     var headers = JSON.stringify( testConfig.headers )|| {};
//     console.log("___________________________",headers)
//     headers = headers.replace("\"`","`");
//     headers = headers.replace("`\"","`");

//     console.log("___________________________",headers)

//     const statusCode = testConfig.expectedStatusCode;
//     const outputObject = {};

//     let testSteps = `  // ${method.toUpperCase()} ${url}\n`;
//     testSteps+=`  await test.step('Make request for API:${getcurrentIdentifier()+1} `
//     if(testConfig.isStatusValidation && statusCode) testSteps+=`and check status code `
//     if(testConfig.isKeyValueValidation && testConfig.expectedKeyValue) testSteps+=`and validate key,value `
//     if(testConfig.isExtractkeyValidation && testConfig.expectedkeyAndVariableName) testSteps+=`and extract value `

//     testSteps+=`', async () => {\n        `
//     testSteps += `  const response${getUniqueIdentifier()} = await request.${method}('${url}', {\n`;
//     testSteps=testSteps.replace("'","`")
//     testSteps=testSteps.replace("'","`")
//     if (testConfig.headers) {
//       testSteps += `    headers: ${headers},\n`;
//     }

//     requestBody.forEach(item => {
//         outputObject[item.paramkey] = item.paramvalue;

//         if(item.isFakerEnabled){
//             if(item.fakertype=="Name"){
//                 outputObject[item.paramkey] =`\${faker.person.fullName()}`
//             }
//             else if(item.fakertype=="Address"){
//                 outputObject[item.paramkey] =`\${faker.person.streetAddress()}`
//             }
//             else if(item.fakertype=="Email"){
//                 outputObject[item.paramkey] =`\${faker.person.email()}`
//             }
//             else if(item.fakertype=="UserName"){
//                 outputObject[item.paramkey] =`\${faker.person.userName()}`
//             }
//             else if(item.fakertype=="Password"){
//                 outputObject[item.paramkey] =`\${faker.person.password()}`
//             }
//             else if(item.fakertype=="Number"){
//                 outputObject[item.paramkey] =`\${faker.person.number()}`
//             }
//             else if(item.fakertype=="FutureDate"){
//                 outputObject[item.paramkey] =`\${faker.person.future()}`
//             }
//             else if(item.fakertype=="CompanyName"){
//                 outputObject[item.paramkey] =`\${faker.person.companyName()}`
//             }
//         }
//       });
  

//     if (requestBody.length > 0) {
//       testSteps += `     data: ${JSON.stringify(outputObject).replace(/"(\${[^}]+})"/g, (_, p1) => `\`${p1}\``)}`;
//     }
  
//     testSteps += `  });\n\n`;

//   console.log(statusCode,"<-code:trueorfalse->",testConfig.isStatusValidation)

//     if (testConfig.isStatusValidation && statusCode) {
//     //   testSteps += `  expect(response${getcurrentIdentifier()}.status()).toBe(${statusCode});\n`;
//     testSteps += `const temp = response${getcurrentIdentifier()}.status(); \n
//     await test.step(\`Expected Status Code: ${statusCode}  Received Status Code: \${temp}\`, async () => {\n
//       expect(response${getcurrentIdentifier()}.status()).toBe(${statusCode});\n
//       console.log('Status code of response${getcurrentIdentifier()} is:', response${getcurrentIdentifier()}.status());\n
//     }); \n`;
//     }
  
//     if (testConfig.isKeyValueValidation && testConfig.expectedKeyValue) {
//       for (let [key, value] of Object.entries(testConfig.expectedKeyValue)) {
//         // testSteps += `  expect(await response${getcurrentIdentifier()}.json()).toHaveProperty('${key}', '${value}');\n`;
//         testSteps+=`
//         await test.step('response${getcurrentIdentifier()} has property "${key}" with value "${value}"', async () => {\n 
//               expect(await response${getcurrentIdentifier()}.json()).toHaveProperty('${key}', '${value}');\n        });\n`;
//       }
//     }
//     if (testConfig.isExtractkeyValidation && testConfig.expectedkeyAndVariableName) {
//         console.log('Extract key validation',Object.entries(testConfig.expectedkeyAndVariableName));
//         for (let [key, variableName] of Object.entries(testConfig.expectedkeyAndVariableName)) {
//           testSteps += `  const ${variableName+"demo"} = await response${getcurrentIdentifier()}.json();\n`;
//           testSteps += `  const ${variableName} =${variableName+"demo"}['${key}'];\n`;

//         }
//       }

//       if (testConfig.validateSchema && testConfig.responseSchema) {
//         testSteps += `  const responseBodyJson = await response${getcurrentIdentifier()}.json();\n`;
//         testSteps += `  await test.step('Validate Response Schema', async () => {\n`;
//         testSteps += `    const ajv = new Ajv();\n`;
//         // testSteps += `  let obj =  ${testConfig.responseSchema}  \n
//         // let convertedSchemaObject = {};\n
//         //  for (const key in obj) {\n
//         //        convertedSchemaObject[key] = { type: typeof obj[key] };\n
//         //        }\n
//         //  const modifiedSchemaObject = { \n
//         //         type: 'object',\n
//         //         properties: convertedSchemaObject,\n
//         //         required: Object.keys(convertedSchemaObject),\n
//         //       };\n
//         // `;

//         // const generateSchema = (data) => {
//         //     let convertedSchemaObject = {};
          
//         //     if (Array.isArray(data)) {
//         //       // If it's an array, create a schema for array items
//         //       convertedSchemaObject = {
//         //         type: 'array',
//         //         items: generateSchema(data[0]), // Assuming all array items have the same structure
//         //       };
//         //     } else if (typeof data === 'object') {
//         //       // If it's an object, create a schema for object properties
//         //       for (const key in data) {
//         //         convertedSchemaObject[key] = { type: typeof data[key] };
//         //       }
//         //     } else {
//         //       // Handle other data types as needed
//         //     }
          
//         //     const modifiedSchemaObject = {
//         //       type: Array.isArray(data) ? 'array' : 'object',
//         //       properties: convertedSchemaObject,
//         //       required: Object.keys(convertedSchemaObject),
//         //     };
          
//         //     return modifiedSchemaObject;
//         //   };

//         function convertJsonToSchema(jsonData, title = 'Generated schema for Root') {
// jsonData = JSON.parse(jsonData)            
//             if (!Array.isArray(jsonData) && typeof jsonData !== 'object') {
//                 throw new Error('Invalid JSON data. Must be an object or an array.');
//             }
          
//             const schema = {
//               $schema: 'http://json-schema.org/draft-07/schema#',
//               title: title,
//               type: Array.isArray(jsonData) ? 'array' : 'object',
//             };
          
//             if (Array.isArray(jsonData)) {
//               if (jsonData.length > 0) {
//                 const sampleObject = jsonData[0];
//                 schema.items = {
//                   type: 'object',
//                   properties: {},
//                   required: Object.keys(sampleObject),
//                 };
          
//                 for (const key in sampleObject) {
//                   schema.items.properties[key] = { type: typeof sampleObject[key] };
//                 }
//               }
//             } else {
//               schema.properties = {};
          
//               for (const key in jsonData) {
//                 schema.properties[key] = { type: typeof jsonData[key] };
//               }
          
//               schema.required = Object.keys(jsonData);
//             }
          
//             return schema;
//           }


//           const schemaForObject =  convertJsonToSchema(testConfig.responseSchema);
//         //    validator.make(testConfig.responseSchema);

//        console.log(testConfig.responseSchema,"+++++++++++++++++++++++++++++++++++++++++++",schemaForObject)
//        testSteps += `    const schemaexp = ${JSON.stringify(schemaForObject)};\n`;
//         testSteps += `    const validate = ajv.compile(schemaexp);\n`;
//         testSteps += `    const isValid = validate(responseBodyJson);\n`;
//         testSteps += `    expect(isValid).toBeTruthy();\n`;        
//         testSteps += `  });\n`;
//       }
      

      
//       testSteps+=`\n  });`
  
//     return testSteps;
// }

// // Function to generate a unique identifier for variable names
// let uniqueIdentifierCounter = 0;

// function getUniqueIdentifier() {
//     uniqueIdentifierCounter += 1;
//     return uniqueIdentifierCounter;
// }
// function getcurrentIdentifier() {return uniqueIdentifierCounter}
  

// module.exports = {
//     getApiInfo,
//     getAllDataAndParse,
//     convertToPlaywright
//   };
  

function generateTestSteps(testConfig) {
    const method = testConfig.method.toLowerCase();
    const url = testConfig.url;
    const requestBody =  JSON.parse(testConfig.requestBody) || [];
    console.log("reqqq",requestBody)
    var headers = JSON.stringify( testConfig.headers )|| {};
    console.log("___________________________",headers)
    headers = headers.replace("\"`","`");
    headers = headers.replace("`\"","`");


    console.log("___________________________",headers)


    const statusCode = testConfig.expectedStatusCode;
    const outputObject = {};


    let testSteps = `  // ${method.toUpperCase()} ${url}\n`;
    // testSteps+=`  await test.step('Make request for API:${getcurrentIdentifier()+1} `
    // if(testConfig.isStatusValidation && statusCode) testSteps+=`and check status code `
    // if(testConfig.isKeyValueValidation && testConfig.expectedKeyValue) testSteps+=`and validate key,value `
    // if(testConfig.isExtractkeyValidation && testConfig.expectedkeyAndVariableName) testSteps+=`and extract value `


    // testSteps+=`', async () => {\n        `
    testSteps += `  const response${getUniqueIdentifier()} = await request.${method}('${url}', {\n`;
    testSteps=testSteps.replace("'","`")
    testSteps=testSteps.replace("'","`")
    if (testConfig.headers) {
      testSteps += `    headers: ${headers},\n`;
    }


    requestBody.forEach(item => {
        outputObject[item.paramkey] = item.paramvalue;


        if(item.isFakerEnabled){
            if(item.fakertype=="Name"){
                outputObject[item.paramkey] =`\${faker.person.fullName()}`
            }
            else if(item.fakertype=="Address"){
                outputObject[item.paramkey] =`\${faker.person.streetAddress()}`
            }
            else if(item.fakertype=="Email"){
                outputObject[item.paramkey] =`\${faker.person.email()}`
            }
            else if(item.fakertype=="UserName"){
                outputObject[item.paramkey] =`\${faker.person.userName()}`
            }
            else if(item.fakertype=="Password"){
                outputObject[item.paramkey] =`\${faker.person.password()}`
            }
            else if(item.fakertype=="Number"){
                outputObject[item.paramkey] =`\${faker.person.number()}`
            }
            else if(item.fakertype=="FutureDate"){
                outputObject[item.paramkey] =`\${faker.person.future()}`
            }
            else if(item.fakertype=="CompanyName"){
                outputObject[item.paramkey] =`\${faker.person.companyName()}`
            }
        }
      });
 


    if (requestBody.length > 0) {
      testSteps += `     data: ${JSON.stringify(outputObject).replace(/"(\${[^}]+})"/g, (_, p1) => `\`${p1}\``)}`;
    }
 
    testSteps += `  });\n\n`;


  console.log(statusCode,"<-code:trueorfalse->",testConfig.isStatusValidation)


    if (testConfig.isStatusValidation && statusCode) {
      testSteps += `const recievedStatusCode${getcurrentIdentifier()}=response${getcurrentIdentifier()}.status();\n 
       expect(response${getcurrentIdentifier()}.status(),\`Expected status code: ${statusCode}, Recieved status code: \${recievedStatusCode${getcurrentIdentifier()}} \`).toBe(${statusCode});\n`;
    // testSteps += `const temp = response${getcurrentIdentifier()}.status(); \n
    // await test.step(\`Expected Status Code: ${statusCode}  Received Status Code: \${temp}\`, async () => {\n
    //   expect(response${getcurrentIdentifier()}.status()).toBe(${statusCode});\n
    //   console.log('Status code of response${getcurrentIdentifier()} is:', response${getcurrentIdentifier()}.status());\n
    // }); \n`;


    }
 
    if (testConfig.isKeyValueValidation && testConfig.expectedKeyValue) {
      for (let [key, value] of Object.entries(testConfig.expectedKeyValue)) {
        testSteps += `  expect(await response${getcurrentIdentifier()}.json()).toHaveProperty('${key}', '${value}');\n`;
        // testSteps+=`
        // await test.step('response${getcurrentIdentifier()} has property "${key}" with value "${value}"', async () => {\n
        //       expect(await response${getcurrentIdentifier()}.json()).toHaveProperty('${key}', '${value}');\n        });\n`;
      }
    }
    if (testConfig.isExtractkeyValidation && testConfig.expectedkeyAndVariableName) {
        console.log('Extract key validation',Object.entries(testConfig.expectedkeyAndVariableName));
        for (let [key, variableName] of Object.entries(testConfig.expectedkeyAndVariableName)) {
          testSteps += `  const ${variableName+"demo"} = await response${getcurrentIdentifier()}.json();\n`;
          testSteps += `  const ${variableName} =${variableName+"demo"}['${key}'];\n`;


        }
      }


      if (testConfig.validateSchema && testConfig.responseSchema) {
        testSteps += `  const responseBodyJson = await response${getcurrentIdentifier()}.json();\n`;
        testSteps += `  await test.step('Validate Response Schema for API response${getcurrentIdentifier()}', async () => {\n`;
        testSteps += `    const ajv = new Ajv();\n`;


        function convertJsonToSchema(jsonData, title = 'Generated schema for Root') {
                jsonData = JSON.parse(jsonData)            
            if (!Array.isArray(jsonData) && typeof jsonData !== 'object') {
                throw new Error('Invalid JSON data. Must be an object or an array.');
            }
         
            const schema = {
              $schema: 'http://json-schema.org/draft-07/schema#',
              title: title,
              type: Array.isArray(jsonData) ? 'array' : 'object',
            };
         
            if (Array.isArray(jsonData)) {
              if (jsonData.length > 0) {
                const sampleObject = jsonData[0];
                schema.items = {
                  type: 'object',
                  properties: {},
                  required: Object.keys(sampleObject),
                };
         
                for (const key in sampleObject) {
                  schema.items.properties[key] = { type: typeof sampleObject[key] };
                }
              }
            } else {
              schema.properties = {};
         
              for (const key in jsonData) {
                schema.properties[key] = { type: typeof jsonData[key] };
              }
         
              schema.required = Object.keys(jsonData);
            }
         
            return schema;
          }


          const schemaForObject =  convertJsonToSchema(testConfig.responseSchema);
        //    validator.make(testConfig.responseSchema);


       console.log(testConfig.responseSchema,"+++++++++++++++++++++++++++++++++++++++++++",schemaForObject)
       testSteps += `    const schemaexp = ${JSON.stringify(schemaForObject)};\n`;
        testSteps += `    const validate = ajv.compile(schemaexp);\n`;
        testSteps += `    const isValid = validate(responseBodyJson);\n`;
        testSteps += `    expect(isValid).toBeTruthy();\n`;        
        testSteps += `  });\n`;
      }
     


     
    //   testSteps+=`\n  });`
 
    return testSteps;
}


// Function to generate a unique identifier for variable names
let uniqueIdentifierCounter = 0;


function getUniqueIdentifier() {
    uniqueIdentifierCounter += 1;
    return uniqueIdentifierCounter;
}
function getcurrentIdentifier() {return uniqueIdentifierCounter}
 


module.exports = {
    getApiInfo,
    getAllDataAndParse,
    convertToPlaywright
  };