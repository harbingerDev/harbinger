const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const db = require("./db/harbinger");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(function (err, req, res, next) {
  console.error(err.stack);
  res.status(500).send("Something broke!");
});

//Everything related to projects
app.get("/projects/getProjects", async (req, res) => {
  const projects = await db.getAllProjects();
  res.status(200).json(projects);
});
app.get("/projects/getActiveProject", async (req, res) => {
  const id = await db.getActiveProject();
  res.status(200).json(id);
});

app.post("/projects/createProject", async (req, res) => {
  const results = await db.createProject(req.body);
  res.status(201).json({ id: results[0] });
});

app.put("/projects/activate/:id", async (req, res) => {
  const id = await db.activateProject(req.params.id);
  res.status(200).json({ id });
});

app.delete("/projects/delete/:id", async (req, res) => {
  const id = await db.deleteProject(req.params.id);
  res.status(200).json({ success: true });
});

//Everything related to scripts
app.post("/scripts/createScript", async (req, res) => {
  const results = await db.createScript(req.body);
  res
    .status(results === true ? 201 : 500)
    .json(results === true ? { success: true } : { success: false });
});
app.post("/scripts/getScripts", async (req, res) => {
  const scripts = await db.getScripts(req.body);
  res.status(200).json(scripts);
});

//Everything related to runs
app.post("/runs/executeScript", async (req, res) => {
  const results = await db.executeScript(req.body);
  res
    .status(results === true ? 201 : 500)
    .json(results === true ? { success: true } : { success: false });
});
app.post("/runs/executeScripts", async (req, res) => {
  const results = await db.executeScripts(req.body);
  res
    .status(results === true ? 201 : 500)
    .json(results === true ? { success: true } : { success: false });
});

//everything related to system
app.get("/system/checkNodeVersion", async (req, res) => {
  const nodeVersion = await db.checkNodeVersion();
  res.status(200).json({ nodeVersion });
});

app.get("/system/checkGitVersion", async (req, res) => {
  const gitVersion = await db.checkGitVersion();
  res.status(200).json({ gitVersion });
});

//AST related
app.post("/ast/getASTFromFile", async (req, res) => {
  const ast = await db.getASTFromFile(req.body);
  res.status(201).json(ast);
});

app.listen(1337, () => console.log("server running on port 1337"));
