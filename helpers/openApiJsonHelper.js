const swaggerJSDoc = require('swagger-jsdoc');
const fs = require("fs");
const path = require('path');
const os = require("os");
const { exec } = require('child_process');

function generateSwaggerDocs(codeFilePath,projectName,projectLanguage) {
  if(projectLanguage=="JavaScript"){
 return generateOpenApiForJavaScript(codeFilePath,projectName)
}
else if(projectLanguage=="Java"){
    return generateOpenApiForJava(codeFilePath,projectName)
}
}

function searchExpressionInPath(projectFolderPath) {
  let resultFilePath = null;

  function searchInDirectory(directoryPath) {
    const files = fs.readdirSync(directoryPath);

    files.forEach((file) => {
      const filePath = path.join(directoryPath, file);
      const stats = fs.statSync(filePath);

      if (stats.isDirectory()) {
        searchInDirectory(filePath);
      } else if (stats.isFile()) {
        const fileContent = fs.readFileSync(filePath, 'utf-8');

        // Use regex to search for the expression require("express")
        const expressionRegex = /\brequire\s*\(\s*["']express["']\s*\)\s*;/;
        if (expressionRegex.test(fileContent)) {
          resultFilePath = filePath;
        }
      }
    });
  }

  searchInDirectory(projectFolderPath);

  if (resultFilePath) {
    console.log(`Expression found in file: ${resultFilePath}`);
    return resultFilePath;
  } else {
    console.log('Expression not found in any file.');
    return null;
  }
}

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
function generateOpenApiForJavaScript(codeFilePath,projectName){
  if(!fs.statSync(codeFilePath).isFile()){
    codeFilePath=searchExpressionInPath(codeFilePath);
  }
  try {
    const code = fs.readFileSync(codeFilePath, 'utf-8');
    const swaggerAnnotations =  generateSwaggerAnnotations(code);
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
    const documentsPath = path.join(os.homedir(), "Documents");
    
    

    const outputFile = projectName+'_openapi.json';
  const filesavedpath= path.join(documentsPath,outputFile);

    fs.writeFileSync(filesavedpath, JSON.stringify(swaggerSpec, null, 2));

    // console.log(`Swagger documentation has been generated and saved to ${outputFile}`);

    return filesavedpath;
  } catch (error) {
    console.error(error);
    return { error: 'Internal server error.' };
  }
}



function cloneGitHubRepository(githubRepoUrl, destinationPath) {
  return new Promise((resolve, reject) => {
    const command = `git clone ${githubRepoUrl} ${destinationPath}`;

    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.error(`Error cloning repository: ${stderr}`);
        reject(new Error('Error cloning repository'));
      } else {
        console.log('Repository cloned successfully.');
        resolve(destinationPath);
      }
    });
  });
}

function clonegithubintolocalpath(githubRepoUrl) {

  const documentsPath = path.join(os.homedir(), "Documents");

// Regular expression to validate GitHub repository URL
const repoUrlPattern = /^https:\/\/github\.com\/[a-zA-Z0-9._-]+\/[a-zA-Z0-9._-]+\.git$/;

if (repoUrlPattern.test(githubRepoUrl)) {
  console.log('Valid GitHub repository URL');

  // Extract repository name using regex
  const repoNamePattern = /\/([a-zA-Z0-9._-]+)\.git$/;
  const match = githubRepoUrl.match(repoNamePattern);
  let repoName ="demo"
  if (match) {
     repoName = match[1];
    console.log('Repository Name:', repoName);
  } else {
    console.log('Unable to extract repository name');
  }

//clone the repository in documentsPath
console.log(githubRepoUrl,documentsPath)
const githubprojectclonedlocalpath = path.join(documentsPath, repoName);


cloneGitHubRepository(githubRepoUrl, githubprojectclonedlocalpath)
  .then((clonedPath) => {
    console.log('Cloned repository path:', clonedPath);
  })
  .catch((error) => {
    console.error(error.message);
  });

  return githubprojectclonedlocalpath

} else {
  console.log('Invalid GitHub repository URL');
  throw new Error('Invalid GitHub repository URL');
}
}



async function analyzeLanguage(filePath)  {
  try {
    console.log("inside analysing language")
    const stats = fs.statSync(filePath);
    console.log(filePath,"path",path.basename(filePath));

    if (stats.isDirectory()) {
      console.log("inside...folder")
      // If it's a directory, analyze all files in the directory and its subdirectories
      console.log(filePath)
      const files = await getFiles(filePath);

      const languages = {};

      files.forEach((file) => {
        const fileExtension = path.extname(file).toLowerCase();
        if(detectLanguageByExtension(fileExtension)!=null){
        const language = detectLanguageByExtension(fileExtension);
        languages[language] = (languages[language] || 0) + 1;
        }
      });

      const maxLanguage = Object.keys(languages).reduce((a, b) => (languages[a] > languages[b] ? a : b));

      return {
        result: 'Analysis successful',
        languages,
        maxLanguage,
      };
    } else if (stats.isFile()) {
      // If it's a file, analyze the language of that file
      const fileExtension = path.extname(filePath).toLowerCase();
      const language = detectLanguageByExtension(fileExtension);

      return {
        result: 'Analysis successful',
        languages: { [language]: 1 },
        maxLanguage: language,
      };
    } else {
      return { result: 'Cannot analyze', languages: {}, maxLanguage: 'N/A' };
    }
  } catch (error) {
    return { result: 'Error analyzing', error: error.message, languages: {}, maxLanguage: 'N/A' };
  }
}

function getFiles(dir) {
  const files = [];
  const dirents = fs.readdirSync(dir, { withFileTypes: true });

  for (const dirent of dirents) {
    const fullPath = path.join(dir, dirent.name);


    // Ignore folders named 'node_modules' or 'target'
    if (dirent.isDirectory() && ( dirent.name === 'README.md'|| dirent.name === 'pom.xml'||dirent.name === 'harbinger.sqlite3'||dirent.name === '.gitignore' ||dirent.name === 'node_modules' || dirent.name === '.git' || dirent.name === 'target')) {
      continue;
    }

    if (dirent.isDirectory()) {
      files.push(...getFiles(fullPath));
    } else {
      files.push(fullPath);
    }
  }

  return files;
}
function detectLanguageByExtension(fileExtension) {
  switch (fileExtension) {
    case '.js':
      return 'JavaScript';
    case '.py':
      return 'Python';
    case '.java':
      return 'Java';
    default:
      return null; // or any other value you want to represent "unknown" or "unsupported"
  }
}

// Function to detect controller classes
function detectControllers(javaCode) {
  const regex = /@RestController|@Controller/g;
  const matches = javaCode.match(regex);

  return matches ? true : false;
}

// Function to detect model classes
function detectModels(javaCode) {
  const regex = /@Entity|@Table/g;
  const matches = javaCode.match(regex);

  return matches ? true : false;
}

function scanDirectory(directory) {
  const files = fs.readdirSync(directory);

  let controllers = [];
  let models = [];

  files.forEach(file => {
    const filePath = path.join(directory, file);

    if (fs.statSync(filePath).isDirectory()) {
      const subdirectoryResults = scanDirectory(filePath);
      controllers = controllers.concat(subdirectoryResults.controllers);
      models = models.concat(subdirectoryResults.models);
    } else if (file.endsWith('.java')) {
      const javaCode = readJavaFiles(filePath);

      if (detectControllers(javaCode)) {
        controllers.push(filePath);
      }

      if (detectModels(javaCode)) {
        models.push(filePath);
      }
    }
  });

  return { controllers, models };
}


// Function to scan a directory for Java files and detect controllers and models
function scanProjectForControllersAndModels(projectPath) {
  return scanDirectory(projectPath);
}

// Function to generate OpenAPI JSON
async function generateOpenApiForJava(projectPath,projectName) {
  // if(!fs.statSync(codeFilePath).isFile()){
  // }

 const{ controllers, models  }= scanProjectForControllersAndModels(projectPath);

console.log('Detected Controllers:', controllers);
console.log('Detected Models:', models);
const controllerspatharr=controllers
const modelspatharr=models
//main game starts now !...
const controllerschema=createFinalSchemaForController(controllerspatharr);
console.log("printing controller schemas",controllerschema)
const modelschema=createFinalSchemaForModel(modelspatharr);
console.log("printing model schemas",modelschema)

  // i will give the schema of both and you create it 
  const openApiJsoncontent = generateOpenApi(controllerschema, modelschema);
  const documentsPath = path.join(os.homedir(), "Documents");
  const finalpath= path.join(documentsPath, "jsonfile");
  console.log(finalpath,documentsPath)

  if (!fs.existsSync(finalpath)) {
    fs.mkdirSync(finalpath, { recursive: true });
    console.log(`Directory created: ${finalpath}`);
  } else {
    console.log(`Directory already exists: ${finalpath}`);
  }
  
  const filePath = path.join(finalpath, `_harbingeranalyser.json`);
  fs.writeFileSync(filePath, JSON.stringify(openApiJsoncontent, null, 2));
  console.log('OpenAPI documentation has been generated and saved to openapi.json');
  
  return filePath;
}

function createFinalSchemaForController(controllerspatharr){
  let paths={}

  controllerspatharr.forEach(eachcontrollerpath=>{
    const controllerCode = readJavaFiles(eachcontrollerpath);
    paths=Object.assign({},paths,parseControllers(controllerCode)) ;

  })
  return paths
}

function parseControllers(controllerCode){
  const paths={}
  let globalPath=""

    // Use regex to extract the global path
    const pathRegex = /@\s*RequestMapping\s*\(\s*"([^"]+)"\s*\)\s*public\s*class\s*(\w+)/;
    const pathMatch = controllerCode.match(pathRegex);
    globalPath = pathMatch ? pathMatch[1] : "";

    // Use regex to remove all code above the class
    const classRegex = /(class.*?{[\s\S]*})/;
    const classMatch = controllerCode.match(classRegex);
    const classCode = classMatch ? classMatch[1] : null;

  const methodArr = [];
  const regex = /@[a-zA-Z]+Mapping[\s\S]*?return .*?;/g;
  let match;
  while ((match = regex.exec(classCode)) !== null) {
    methodArr.push(match[0]);
  }

  methodArr.forEach(
    (apiCode)=>{
    const {key, value}=generateSchemaForMethod(apiCode,globalPath);  
    paths[key]=value;
    }
  )

  return paths;
}

function generateSchemaForMethod(apiCode,globalpath){
  //method
  console.log("codestart",apiCode,"end")
  let method="null"
  let path="" 
  let requestBodytype="";
  let requestBodyvariablename="";
  let response="";
  const methodRegex1 = /@(\w+)Mapping/g;
  const methodRegex2 = /RequestMethod\.(\w+)/;
  const match1 = methodRegex1.exec(apiCode);
  const match2 = methodRegex2.exec(apiCode);
  if (match1 && match1[1]!=null &&  match1[1]!="Request") {
    method= match1[1].toUpperCase();
  }
  else if (match2 && match2[1]!=null) {
    method= match2[1].toUpperCase();
  }
  else{
    console.log("******api method printed check the method as its null->>>>>>",apiCode)
  }

 const pathregex1 = /Mapping\(value\s*=\s*["']([^"']+)["']\)/;
  const pathregex2=/Mapping\(["']([^"']+)["']\)/;
  const matchpathregex1 = apiCode.match(pathregex1);
  const matchpathregex2 = apiCode.match(pathregex2);

  if (matchpathregex1 && matchpathregex1[1]) {
    path= matchpathregex1[1];
  }
  else if (matchpathregex2 && matchpathregex2[1]){
    path= matchpathregex2[1];
  }


  const requestBodyRegex =/@RequestBody\s+(\w+(?:\s*<\s*\w+\s*>)?)\s+(\w+)/;

  // Search for @RequestBody annotation in the code
  const requestBodyMatch = apiCode.match(requestBodyRegex);

  if (requestBodyMatch) {
    // Extracted type and variable from @RequestBody annotation
     requestBodytype = requestBodyMatch[1];
     requestBodyvariablename = requestBodyMatch[2];
  } 

  
const regex1 = /ResponseEntity<List<(\w+)>/;
const regex2 = /ResponseEntity<(\w+)>/;

const responsematch1 = apiCode.match(regex1);
const responsematch2 = apiCode.match(regex2);


if (responsematch1&& responsematch1[1]) {
   response = responsematch1[1];
} else if (responsematch2 && responsematch2[1]) {
  response = responsematch2[1];
} 

if(requestBodytype=="int"||requestBodytype=="String"||requestBodytype=="integer")requestBodytype=""
if(response=="int"||response=="String"||response=="integer")response=""

 const api= new Api(method,globalpath+path,requestBodytype,requestBodyvariablename,response)
return { key:[api.path],
 value:{
    [api.method.toLowerCase()]: {
      tags: [api.requestBodyType.toLowerCase()],
      summary: api.summary || '',
      operationId: api.operationId || '',
      ...(api.requestBodyType
        ? {
            requestBody: {
              content: {
                'application/json': {
                  schema: {
                    $ref: `#/components/schemas/${api.requestBodyType}`
                  }
                }
              },
              required: true
            }
          }
        : {}),
      responses: {
        ...(api.response
          ? {
        200: {
          description: 'Successful Response',
          content: {
            'application/json': {
              schema: {
                $ref: `#/components/schemas/${api.response}`
              }
            }
          }
        }
      }:{}),
        422: {
          description: 'Validation Error',
          content: {
            'application/json': {
              schema: {
                $ref: '#/components/schemas/HTTPValidationError'
              }
            }
          }
        }
      }
    }
  }}
  

}


function createSchemaForEachControllerClass(parsedControllers){

  // Populate paths from controllers
  // controllers.forEach(controller => {
  //   openApiJson.paths[controller] = {
  //     get: {
  //       summary: 'Controller endpoint summary',
  //       // Add more method properties as needed
  //     },
  //     // Add more HTTP methods as needed
  //   };
  // });

}

function createFinalSchemaForModel(modelspatharr){
  let schemas={};

  modelspatharr.forEach(eachModelpath=>{
    const modelCode = readJavaFiles(eachModelpath);
    const scheme={}
   const { key,value} = createSchemaForEachModelClass(modelCode)
   scheme[key]=value;
    schemas=Object.assign({},schemas,scheme)
  })

  return schemas
}


function createSchemaForEachModelClass(javaCode){

    // Extract class name
    const classNameMatch = javaCode.match(/class (\w+)/);
    if (!classNameMatch) {
      throw new Error('Class name not found in Java code');
    }
    const className = classNameMatch[1];
  
    // Extract fields
    const fieldsMatch = javaCode.match(/private (\w+) (\w+);/g);
    if (!fieldsMatch) {
      throw new Error('No fields found in Java code');
    }
  
    const properties = {};
    fieldsMatch.forEach((field) => {
      const fieldMatch = field.match(/private (\w+) (\w+);/);
      if (fieldMatch) {
        const fieldType = mapFieldType(fieldMatch[1]);
        const fieldName = fieldMatch[2];
  
        properties[fieldName] = {
          type: fieldType,
          title: fieldName,
        };
      }
    });
  
    // Generate JSON schema

   return {key:  [className],value:{
        properties,
        type: 'object',
        required: [],
        title: className,
      }}

    // console.log("without stringify",jsonSchema)

    // console.log("stringifying",JSON.stringify(jsonSchema, null, 2))
    // return JSON.stringify(jsonSchema, null, 2);
  }


function mapFieldType(javaType) {
  // You can extend this mapping based on your specific needs
  switch (javaType) {
    case 'String':
      return 'string';
    case 'int':
    case 'Long':
    case 'Integer':
      return 'integer';
    // Add more mappings as needed
    default:
      return 'unknown';
  }
}

function generateOpenApi(controllers, models){

  const openApiJson = {
    openapi: '3.0.0',
    info: {
      title: 'Your API Title',
      version: '1.0.0',
    },
    paths: {},
    components: {
      schemas: {},
    },
  };



  openApiJson.paths=controllers
  openApiJson.components.schemas=models
  console.log(openApiJson)


  return openApiJson;

}

// Function to read Java files
function readJavaFiles(filePath) {
  return fs.readFileSync(filePath, 'utf-8');
}



module.exports = { generateSwaggerDocs ,clonegithubintolocalpath,analyzeLanguage };












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


class Api {
  constructor(method, path, requestBodyType,requestBodyName,response) {
    this.method = method;
    this.path = path;
    this.requestBodyType = requestBodyType;
    this.requestBodyName = requestBodyName;
    this.response=response
  }
}