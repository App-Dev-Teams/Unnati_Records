const express = require("express");
const requireLogin = require("../middlewares/requireLogin");
const authorize = require("../middlewares/authorize");
const {
  uploadQuiz,
  getQuizzes,
  getQuiz,
  submitQuiz
} = require("../controllers/quiz.controller");

const quizRouter = express.Router();

quizRouter.post(
  "/upload_quiz",
  requireLogin,
  authorize("MANAGE_QUIZZES"),
  uploadQuiz
);

quizRouter.get("/get_quizzes", requireLogin, getQuizzes);
quizRouter.get("/get_quiz/:id", requireLogin, getQuiz);
quizRouter.post("/take_quiz/:id/submit", requireLogin, submitQuiz);

module.exports = quizRouter;
