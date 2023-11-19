const swaggerJSDoc = require('swagger-jsdoc');
const fs = require("fs");


function generateSwaggerAnnotations(code) {
  const annotations = [];
  const endpointRegex = /app\.(get|post|put|delete)\(["'](.*?)["'].*?\(.*?(req|request).*?,.*?(res|response).*?\).*?\{/g;

  let match;
  while ((match = endpointRegex.exec(code)) !== null) {
    const method = match[1].toLowerCase();
    const path = match[2];

    const swaggerAnnotation = `
/**
 * @swagger
 * ${path}:
 *   ${method}:
 *     summary: [Summary Here]
 *     description: [Description Here]
 *     responses:
 *       '200':
 *         description: Successful response
 *         content:
 *           application/json:
 *             example: [Example JSON]
 */
`;

    annotations.push(swaggerAnnotation);
  }

  return annotations.join('\n');
}

function generateSwaggerDocs(codeFilePath) {
  try {
    const code = fs.readFileSync(codeFilePath, 'utf-8');
    const swaggerAnnotations = generateSwaggerAnnotations(code);
    const annotationsFilePath = 'swagger_annotations.js';
    fs.writeFileSync(annotationsFilePath, swaggerAnnotations);

    console.log(`Swagger annotations have been generated and saved to ${annotationsFilePath}`);

    const options = {
      definition: {
        openapi: '3.0.0',
        info: {
          title: 'Your API Title',
          version: '1.0.0',
        },
      },
      apis: [`./swagger_annotations.js`],
    };

    const swaggerSpec = swaggerJSDoc(options);

    // const outputFile = 'openapi.json';
    // fs.writeFileSync(outputFile, JSON.stringify(swaggerSpec, null, 2));

    // console.log(`Swagger documentation has been generated and saved to ${outputFile}`);

    return swaggerSpec;
  } catch (error) {
    console.error(error);
    return { error: 'Internal server error.' };
  }
}

module.exports = { generateSwaggerDocs };





















































// // Function to extract controller information from Java files
// function extractControllers(javaCode) {
//   const controllerRegex = /@RestController(?:[^{]*\{([^}]*\}))/g;
//   const matches = javaCode.match(controllerRegex);

//   if (!matches) {
//     return [];
//   }

//   return matches.map(match => {
//     const methods = [];
//     const methodRegex = /@RequestMapping\(["'](.+?)["']\)(?:[^{]*\{([^}]*\}))/g;
//     let methodMatch;
//     while ((methodMatch = methodRegex.exec(match)) !== null) {
//       const [_, path, methodBody] = methodMatch;
//       methods.push({ path, methodBody });
//     }

//     return { methods };
//   });
// }

// // Function to extract model information from Java files
// function extractModels(javaCode) {
//   const modelRegex = /public class (\w+)(?:[^{]*\{([^}]*\}))/g;
//   const matches = javaCode.match(modelRegex);

//   if (!matches) {
//     return [];
//   }

//   return matches.map(match => {
//     const [_, modelName, fields] = match.split('\n');
//     const properties = fields
//       .trim()
//       .split(';')
//       .map(field => {
//         const [type, name] = field.trim().split(/\s+/).reverse();
//         return { type, name };
//       });

//     return { modelName, properties };
//   });
// }

// // Read Java files
// const controllerFiles = [
//   'path/to/Controller1.java',
//   'path/to/Controller2.java',
//   // Add all your controller files
// ];

// const modelFiles = [
//   'path/to/Model1.java',
//   'path/to/Model2.java',
//   // Add all your model files
// ];

// const controllerJavaCode = controllerFiles.map(file => fs.readFileSync(file, 'utf-8')).join('\n');
// const modelJavaCode = modelFiles.map(file => fs.readFileSync(file, 'utf-8')).join('\n');

// // Extract controller and model information
// const controllers = extractControllers(controllerJavaCode);
// const models = extractModels(modelJavaCode);

// // Generate OpenAPI JSON
// const openApiJson = {
//   openapi: '3.0.0',
//   info: {
//     title: 'Your API Title',
//     version: '1.0.0',
//   },
//   paths: {},
//   components: {
//     schemas: {},
//   },
// };

// controllers.forEach(controller => {
//   controller.methods.forEach(method => {
//     const { path, methodBody } = method;
//     const operationId = path.replace(/\W+/g, '_');
//     openApiJson.paths[path] = {
//       [methodBody.includes('RequestMethod.GET') ? 'get' : 'post']: {
//         summary: operationId,
//         operationId,
//         responses: {
//           '200': {
//             description: 'Successful response',
//           },
//         },
//       },
//     };
//   });
// });

// models.forEach(model => {
//   const { modelName, properties } = model;
//   openApiJson.components.schemas[modelName] = {
//     type: 'object',
//     properties: {},
//   };

//   properties.forEach(property => {
//     openApiJson.components.schemas[modelName].properties[property.name] = {
//       type: property.type,
//     };
//   });
// });

// // Write OpenAPI JSON to a file
// fs.writeFileSync('openapi.json', JSON.stringify(openApiJson, null, 2));

















// ////////////////////////////////////////////////////////////////////////////////////////////////


// // Function to extract information from a Java controller file
// function extractControllerInfo(javaCode) {
//     const endpoints = [];
  
//     // Extract methods and their endpoints
//     const methodRegex = /@RequestMapping\(["'](.+?)["']\)/g;
//     let match;
//     while ((match = methodRegex.exec(javaCode)) !== null) {
//       const endpoint = match[1];
//       endpoints.push(endpoint);
//     }
  
//     return endpoints;
//   }
  
//   // Function to extract information from a Java model file
//   function extractModelInfo(javaCode) {
//     const properties = [];
  
//     // Extract properties
//     const fieldRegex = /private (.+?) (.+?);/g;
//     let match;
//     while ((match = fieldRegex.exec(javaCode)) !== null) {
//       const type = match[1];
//       const name = match[2];
//       properties.push({ name, type });
//     }
  
//     return properties;
//   }

// // Function to generate OpenAPI JSON from controllers and models
// function generateOpenAPI(controllers, models) {
//     const openApiJson = {
//       openapi: '3.0.0',
//       info: {
//         title: 'Your API Title',
//         version: '1.0.0',
//       },
//       paths: {},
//       components: { schemas: {} },
//     };
  
//     // Process controllers
//     controllers.forEach((controller) => {
//       const controllerCode = fs.readFileSync(controller, 'utf-8');
//       const endpoints = extractControllerInfo(controllerCode);
  
//       endpoints.forEach((endpoint) => {
//         openApiJson.paths[endpoint] = {
//           get: {
//             summary: 'Endpoint summary',
//           },
//         };
//       });
//     });
  
//     // Process models
//     models.forEach((model) => {
//       const modelCode = fs.readFileSync(model, 'utf-8');
//       const modelName = path.basename(model, '.java');
//       const properties = extractModelInfo(modelCode);
  
//       openApiJson.components.schemas[modelName] = {
//         type: 'object',
//         properties: {},
//       };
  
//       properties.forEach((property) => {
//         openApiJson.components.schemas[modelName].properties[property.name] = {
//           type: property.type,
//         };
//       });
//     });
  
//     return openApiJson;
//   }
  



// //   // Example usage: Provide an array of controller and model files
// // const controllerFiles = [
// //     'path/to/YourController1.java',
// //     'path/to/YourController2.java',
// //     // Add all your controller files
// //   ];
  
// //   const modelFiles = [
// //     'path/to/YourModel1.java',
// //     'path/to/YourModel2.java',
// //     // Add all your model files
// //   ];
  
// //   const openApiJson = generateOpenAPI(controllerFiles, modelFiles);
  
// //   // Write OpenAPI JSON to file
// //   fs.writeFileSync('openapi.json', JSON.stringify(openApiJson, null, 2));
// //   console.log('OpenAPI JSON has been generated and saved to openapi.json');



// /////////////////////////////////////////////////////////////////////////////////////////
// const express = require('express');
// const bodyParser = require('body-parser');

// const app = express();
// const port = 3000;

// app.use(bodyParser.json());

// app.post('/generate-openapi', (req, res) => {
//   const { controllerClasses, modelClasses } = req.body;

//   try {
//     const openApiJson = generateOpenApiJson(controllerClasses, modelClasses);
//     fs.writeFileSync('openapi.json', JSON.stringify(openApiJson, null, 2));

//     res.status(200).json({ message: 'OpenAPI JSON generated successfully' });
//   } catch (error) {
//     res.status(500).json({ error: 'Failed to generate OpenAPI JSON' });
//   }
// });

// app.listen(port, () => {
//   console.log(`Server is running on port ${port}`);
// });

// function generateOpenApiJson(controllerClasses, modelClasses) {
//   const openApiJson = {
//     openapi: '3.0.0',
//     info: {
//       title: 'Generated API',
//       version: '1.0.0',
//     },
//     paths: {},
//     components: {
//       schemas: {},
//     },
//   };

//   // Extract paths and methods from controllers
//   controllerClasses.forEach(controllerCode => {
//     const paths = extractPathsFromController(controllerCode);
//     Object.assign(openApiJson.paths, paths);
//   });

//   // Extract schemas from model classes
//   modelClasses.forEach(modelCode => {
//     const schema = extractSchemaFromModel(modelCode);
//     openApiJson.components.schemas[modelCode.name] = schema;
//   });

//   return openApiJson;
// }

// function extractPathsFromController(controllerCode) {
//   const paths = {};
//   const regex = /@RequestMapping\(["'](.+?)["']\)/g;
//   const matches = controllerCode.match(regex);

//   if (matches) {
//     matches.forEach(match => {
//       const endpoint = match.replace(/@RequestMapping\(["'](.+?)["']\)/, '$1');
//       paths[endpoint] = {
//         get: {
//           summary: 'Endpoint summary',
//           // Add more method properties as needed
//         },
//         // Add more HTTP methods as needed
//       };
//     });
//   }

//   return paths;
// }

// function extractSchemaFromModel(modelCode) {
//   // Simplified example: Extracting properties from fields
//   const schema = {
//     type: 'object',
//     properties: {},
//   };

//   const regex = /private (\w+) (\w+);/g;
//   const matches = modelCode.match(regex);

//   if (matches) {
//     matches.forEach(match => {
//       const [, type, name] = match.match(/private (\w+) (\w+);/);
//       schema.properties[name] = { type };
//     });
//   }

//   return schema;
// }
// //////////////////////////////////////////////////////////////////////////////////////////////////

// const fs = require('fs');

// function generateOpenAPI(controllerFiles, modelFiles) {
//   const openApiJson = {
//     openapi: '3.0.0',
//     info: {
//       title: 'Your API Title',
//       version: '1.0.0',
//     },
//     paths: {},
//     components: {
//       schemas: {},
//     },
//   };

//   // Read model files and extract schema information
//   modelFiles.forEach(modelFile => {
//     const modelName = getModelNameFromFileName(modelFile);
//     const modelContent = fs.readFileSync(modelFile, 'utf-8');
//     const modelSchemas = extractSchemas(modelContent);

//     openApiJson.components.schemas[modelName] = {
//       type: 'object',
//       properties: modelSchemas,
//     };
//   });

//   // Read controller files and extract path and method information
//   controllerFiles.forEach(controllerFile => {
//     const controllerContent = fs.readFileSync(controllerFile, 'utf-8');
//     const paths = extractPaths(controllerContent);

//     paths.forEach(({ path, method }) => {
//       openApiJson.paths[path] = {
//         [method.toLowerCase()]: {
//           summary: 'Endpoint summary',
//           responses: {
//             '200': {
//               description: 'Successful response',
//               content: {
//                 'application/json': {
//                   schema: {
//                     // Reference to the corresponding model schema
//                     $ref: `#/components/schemas/${getModelNameFromPath(path)}`,
//                   },
//                 },
//               },
//             },
//           },
//         },
//       };
//     });
//   });

//   // Write OpenAPI JSON to file
//   fs.writeFileSync('openapi.json', JSON.stringify(openApiJson, null, 2));
// }

// function getModelNameFromFileName(fileName) {
//   // Extract model name from file name (simplified example)
//   return fileName.replace('.java', '');
// }

// function getModelNameFromPath(path) {
//   // Extract model name from path (simplified example)
//   return path.split('/').pop();
// }

// function extractSchemas(modelContent) {
//   // Implement logic to extract schemas from Java model class
//   // (e.g., using regular expressions or a more sophisticated parser)
//   return {};
// }

// function extractPaths(controllerContent) {
//   // Implement logic to extract paths and methods from Java controller class
//   // (e.g., using regular expressions or a more sophisticated parser)
//   return [];
// }

// // Example usage
// // const controllerFiles = ['path/to/Controller1.java', 'path/to/Controller2.java'];
// // const modelFiles = ['path/to/Model1.java', 'path/to/Model2.java'];

// generateOpenAPI(controllerFiles, modelFiles);


// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// const fs = require('fs');
// const path = require('path');

// // Function to read Java files
// function readJavaFiles(directory) {
//   const files = fs.readdirSync(directory);
//   const javaFiles = files.filter(file => file.endsWith('.java'));

//   return javaFiles.map(file => fs.readFileSync(path.join(directory, file), 'utf-8')).join('\n');
// }

// // Function to parse controllers and extract endpoints
// function parseControllers(javaCode) {
//   const regex = /@RequestMapping\(["'](.+?)["']\)/g;
//   const matches = javaCode.match(regex);

//   return matches ? matches.map(match => match.replace(/@RequestMapping\(["'](.+?)["']\)/, '$1')) : [];
// }

// // Function to parse models and extract schemas
// function parseModels(javaCode) {
//   // Your parsing logic for models here
//   // This is a simplified example; you might use regex or a more sophisticated parser
//   const regex = /class (\w+)[^{]*{/g;
//   const matches = javaCode.match(regex);

//   return matches ? matches.map(match => match.replace(/class (\w+)[^{]*{/, '$1')) : [];
// }

// // Function to generate OpenAPI JSON
// function generateOpenApi(controllers, models) {
//   const openApiJson = {
//     openapi: '3.0.0',
//     info: {
//       title: 'Your API Title',
//       version: '1.0.0',
//     },
//     paths: {},
//     components: {
//       schemas: {},
//     },
//   };

//   // Populate paths from controllers
//   controllers.forEach(controller => {
//     openApiJson.paths[controller] = {
//       get: {
//         summary: 'Controller endpoint summary',
//         // Add more method properties as needed
//       },
//       // Add more HTTP methods as needed
//     };
//   });

//   // Populate schemas from models
//   models.forEach(model => {
//     openApiJson.components.schemas[model] = {
//       type: 'object',
//       // Add more schema properties as needed
//     };
//   });

//   return openApiJson;
// }

// // Main function
// function generateOpenApiForSpringBootProject(controllerDirectory, modelDirectory) {
//   const controllerCode = readJavaFiles(controllerDirectory);
//   const modelCode = readJavaFiles(modelDirectory);

//   const controllers = parseControllers(controllerCode);
//   const models = parseModels(modelCode);

//   const openApiJson = generateOpenApi(controllers, models);

//   fs.writeFileSync('openapi.json', JSON.stringify(openApiJson, null, 2));
//   console.log('OpenAPI documentation has been generated and saved to openapi.json');
// }








// ///////////////////////////////////////////////////////////////////////////////
// const fs = require('fs');
// const path = require('path');

// // Function to read Java files
// function readJavaFiles(directory) {
//   const files = fs.readdirSync(directory);
//   const javaFiles = files.filter(file => file.endsWith('.java'));

//   return javaFiles.map(file => fs.readFileSync(path.join(directory, file), 'utf-8')).join('\n');
// }

// // Function to detect controller classes
// function detectControllers(javaCode) {
//   const regex = /@RestController|@Controller/g;
//   const matches = javaCode.match(regex);

//   return matches ? true : false;
// }

// // Function to detect model classes
// function detectModels(javaCode) {
//   const regex = /@Entity|@Table/g;
//   const matches = javaCode.match(regex);

//   return matches ? true : false;
// }

// // Function to scan a directory for Java files and detect controllers and models
// function scanProjectForControllersAndModels(projectPath) {
//   const files = fs.readdirSync(projectPath);
//   const javaFiles = files.filter(file => file.endsWith('.java'));

//   const controllers = [];
//   const models = [];

//   javaFiles.forEach(file => {
//     const javaCode = fs.readFileSync(path.join(projectPath, file), 'utf-8');

//     if (detectControllers(javaCode)) {
//       controllers.push(file.replace('.java', ''));
//     }

//     if (detectModels(javaCode)) {
//       models.push(file.replace('.java', ''));
//     }
//   });

//   return { controllers, models };
// }

// // Example usage
// const projectPath = 'path/to/your/spring/boot/project';

// // const { controllers, models } = scanProjectForControllersAndModels(projectPath);

// console.log('Detected Controllers:', controllers);
// console.log('Detected Models:', models);


// ////////////////////////////////////////////////////////////////////////////////
// const fs = require('fs');
// const path = require('path');

// // Function to read Java files
// function readJavaFiles(filePath) {
//   return fs.readFileSync(filePath, 'utf-8');
// }

// // Function to detect controller classes
// function detectControllers(javaCode) {
//   const regex = /@RestController|@Controller/g;
//   const matches = javaCode.match(regex);

//   return matches ? true : false;
// }

// // Function to detect model classes
// function detectModels(javaCode) {
//   const regex = /@Entity|@Table/g;
//   const matches = javaCode.match(regex);

//   return matches ? true : false;
// }

// // Recursive function to scan a directory for Java files and detect controllers and models
// function scanDirectory(directory) {
//   const files = fs.readdirSync(directory);

//   let controllers = [];
//   let models = [];

//   files.forEach(file => {
//     const filePath = path.join(directory, file);

//     if (fs.statSync(filePath).isDirectory()) {
//       const subdirectoryResults = scanDirectory(filePath);
//       controllers = controllers.concat(subdirectoryResults.controllers);
//       models = models.concat(subdirectoryResults.models);
//     } else if (file.endsWith('.java')) {
//       const javaCode = readJavaFiles(filePath);

//       if (detectControllers(javaCode)) {
//         controllers.push(file.replace('.java', ''));
//       }

//       if (detectModels(javaCode)) {
//         models.push(file.replace('.java', ''));
//       }
//     }
//   });

//   return { controllers, models };
// }

// // Function to scan a directory for Java files and detect controllers and models
// function scanProjectForControllersAndModels(projectPath) {
//   return scanDirectory(projectPath);
// }

// // // Example usage
// // const projectPath = 'path/to/your/spring/boot/project';

// // const { controllers, models } = scanProjectForControllersAndModels(projectPath);

// console.log('Detected Controllers:', controllers);
// console.log('Detected Models:', models);