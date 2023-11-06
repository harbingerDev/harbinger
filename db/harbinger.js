const path = require("path");
const knex = require("./knex");
const projectHelper = require("../helpers/projectHelpers");

// everything related to projects
async function createProject(project) {
  await projectHelper.createProjectOnDisk(project);
  return knex("projects").insert(project);
}

function getAllProjects() {
  return knex("projects").select("*");
}
function getActiveProject() {
  return knex("active_project").select("*");
}

function getActiveProject() {
  return knex("active_project").select("*");
}

function deleteProject(id) {
  return knex("projects").where("id", id).del();
}
async function getProjectById(id) {
  const project = await knex("projects").where("id", id).first();

  if (!project) {
    throw new Error("Project not found");
  }

  return project;
}


function activateProject(id) {
  knex
    .select()
    .from("active_project")
    .then((rows) => {
      if (rows.length === 0) {
        return knex("active_project")
          .insert({ id: id })
          .then(console.log)
          .catch(console.error);
      } else {
        return knex("active_project").update({ id: id }).limit(1);
      }
    });
}

// everything related to scripts
async function createScript(req) {
  const isCreated = await projectHelper.createScript(req);
  return isCreated;
}
async function getScripts(req) {
  const scriptList = await projectHelper.getScripts(req);
  return scriptList;
}
async function renameScript(req,projectid){

  const project = await getProjectById(projectid);
  const completePath = path.join(project.project_path, project.project_name);
  console.log(completePath)
  projectHelper.renameScript(completePath, req.scriptName)
}

// everything related to runs
async function executeScript(req) {
  const isExecuted = await projectHelper.executeScript(req);
  return isExecuted;
}
async function executeScripts(req) {
  const isExecuted = await projectHelper.executeScripts(req);
  return isExecuted;
}

//everything related to system
async function checkNodeVersion() {
  const nodeVersion = await projectHelper.checkNodeVersion();
  return nodeVersion;
}
async function checkGitVersion() {
  const gitVersion = await projectHelper.checkGitVersion();
  return gitVersion;
}

//AST related
async function getASTFromFile(req) {
  const ast = await projectHelper.getASTFromFile(req);
  return ast;
}
async function getSpecificJSON(req) {
  const ast = await projectHelper.getSpecificAstJSON(req);
  return ast;
}

async function getGodJSON(req) {
  const ast = await projectHelper.getGodJSON(req);
  return ast;
}

module.exports = {
  createProject,
  getAllProjects,
  getProjectById,
  renameScript,
  getActiveProject,
  deleteProject,
  activateProject,
  createScript,
  executeScript,
  checkNodeVersion,
  checkGitVersion,
  getActiveProject,
  getScripts,
  executeScripts,
  getASTFromFile,
  getGodJSON,
  getSpecificJSON,
};
