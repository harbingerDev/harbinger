const swaggerJSDoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'My Swagger API',
      version: '1.0.0',
    },
  },
  apis: ['./server.js'], // Replace with the path to your main application file.
};

const swaggerSpec = swaggerJSDoc(options);

module.exports = swaggerSpec;
