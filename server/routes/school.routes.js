const express = require("express");
const { getSchools } = require("../controllers/school.controller");
const schoolRouter = express.Router();

schoolRouter.get("/get-schools",getSchools);

module.exports = schoolRouter;