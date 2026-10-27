const mongoose = require("mongoose");
const Quiz = require("../models/quiz.model");
const QuizAttempt = require("../models/quizAttempt.model");
const rolePermissions = require("../utils/permission");

const QUIZ_PERMISSION = "MANAGE_QUIZZES";
const QUIZ_STATUSES = new Set(["draft", "published"]);

const isNonEmptyString = (value) =>
  typeof value === "string" && value.trim().length > 0;

const hasQuizPermission = (req) => {
  const role = req.user?.role || req.role;
  return Boolean(role && rolePermissions[role]?.includes(QUIZ_PERMISSION));
};

const validateQuestions = (questions) => {
  if (!Array.isArray(questions) || questions.length === 0) {
    return "At least one question is required";
  }

  const questionIds = new Set();

  for (const question of questions) {
    if (!question || typeof question !== "object" || Array.isArray(question)) {
      return "Each question must be an object";
    }

    if (!isNonEmptyString(question.questionId)) {
      return "Each question requires a questionId";
    }

    const questionId = question.questionId.trim();
    if (questionIds.has(questionId)) {
      return "Question IDs must be unique";
    }
    questionIds.add(questionId);

    if (!isNonEmptyString(question.questionText)) {
      return "Each question requires questionText";
    }

    if (!Array.isArray(question.options) || question.options.length < 2) {
      return "Each question must have at least two options";
    }

    const optionIds = new Set();
    for (const option of question.options) {
      if (!option || typeof option !== "object" || Array.isArray(option)) {
        return "Each option must be an object";
      }

      if (!isNonEmptyString(option.optionId)) {
        return "Each option requires an optionId";
      }

      const optionId = option.optionId.trim();
      if (optionIds.has(optionId)) {
        return "Option IDs must be unique within a question";
      }
      optionIds.add(optionId);

      if (!isNonEmptyString(option.text)) {
        return "Each option requires text";
      }
    }

    if (!isNonEmptyString(question.correctOptionId)) {
      return "Each question requires correctOptionId";
    }

    if (!optionIds.has(question.correctOptionId.trim())) {
      return "correctOptionId must reference an option in the same question";
    }
  }

  return null;
};

const getQuizMetadata = (quiz) => ({
  id: quiz._id,
  title: quiz.title,
  targetClass: quiz.targetClass,
  status: quiz.status,
  questionCount: quiz.questions.length,
  createdBy: quiz.createdBy,
  createdAt: quiz.createdAt,
  updatedAt: quiz.updatedAt
});

const isAuthenticated = (req) => Boolean(req.user?._id);
const isStudent = (req) => req.userType === "student" && isAuthenticated(req);

const getStudentQuiz = async (quizId, studentClass) => {
  if (!mongoose.isValidObjectId(quizId)) {
    return { invalidId: true };
  }

  const quiz = await Quiz.findOne({
    _id: quizId,
    status: "published",
    targetClass: studentClass
  }).select("-questions.correctOptionId -createdBy");

  return { quiz };
};

const getPublishedQuiz = async (quizId) => {
  if (!mongoose.isValidObjectId(quizId)) {
    return { invalidId: true };
  }

  const quiz = await Quiz.findOne({
    _id: quizId,
    status: "published"
  }).select("-questions.correctOptionId -createdBy");

  return { quiz };
};

const getQuizzes = async (req, res) => {
  try {
    if (!isAuthenticated(req)) {
      return res.status(403).json({
        success: false,
        message: "You must be logged in to view quizzes"
      });
    }

    const query = { status: "published" };
    if (isStudent(req)) {
      query.targetClass = req.user.studentClass;
    }

    const quizzes = await Quiz.find(query)
      .select("title targetClass status createdAt updatedAt questions")
      .sort({ createdAt: -1 })
      .lean();

    return res.status(200).json({
      success: true,
      count: quizzes.length,
      data: quizzes.map((quiz) => ({
        id: quiz._id,
        title: quiz.title,
        targetClass: quiz.targetClass,
        status: quiz.status,
        questionCount: quiz.questions.length,
        createdAt: quiz.createdAt,
        updatedAt: quiz.updatedAt
      }))
    });
  } catch (error) {
    console.error("GET QUIZZES ERROR:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};

const getQuiz = async (req, res) => {
  try {
    if (!isAuthenticated(req)) {
      return res.status(403).json({
        success: false,
        message: "You must be logged in to view quizzes"
      });
    }

    const result = isStudent(req)
      ? await getStudentQuiz(req.params.id, req.user.studentClass)
      : await getPublishedQuiz(req.params.id);
    if (result.invalidId) {
      return res.status(400).json({
        success: false,
        message: "Invalid quiz ID"
      });
    }

    if (!result.quiz) {
      return res.status(404).json({
        success: false,
        message: "Quiz not found"
      });
    }

    return res.status(200).json({
      success: true,
      data: {
        id: result.quiz._id,
        title: result.quiz.title,
        targetClass: result.quiz.targetClass,
        questions: result.quiz.questions.map((question) => ({
          questionId: question.questionId,
          questionText: question.questionText,
          options: question.options
        }))
      }
    });
  } catch (error) {
    console.error("GET QUIZ ERROR:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};

const submitQuiz = async (req, res) => {
  try {
    if (!isStudent(req)) {
      return res.status(403).json({
        success: false,
        message: "Only students can submit quizzes"
      });
    }

    if (!mongoose.isValidObjectId(req.params.id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid quiz ID"
      });
    }

    const quiz = await Quiz.findOne({
      _id: req.params.id,
      status: "published",
      targetClass: req.user.studentClass
    });

    if (!quiz) {
      return res.status(404).json({
        success: false,
        message: "Quiz not found"
      });
    }

    const { answers } = req.body || {};
    if (!Array.isArray(answers) || answers.length !== quiz.questions.length) {
      return res.status(400).json({
        success: false,
        message: "Answers for every question are required"
      });
    }

    const questionMap = new Map(
      quiz.questions.map((question) => [question.questionId, question])
    );
    const submittedQuestionIds = new Set();
    let score = 0;

    for (const answer of answers) {
      if (
        !answer ||
        typeof answer !== "object" ||
        !isNonEmptyString(answer.questionId) ||
        !isNonEmptyString(answer.selectedOptionId)
      ) {
        return res.status(400).json({
          success: false,
          message: "Each answer requires questionId and selectedOptionId"
        });
      }

      const questionId = answer.questionId.trim();
      const selectedOptionId = answer.selectedOptionId.trim();
      if (submittedQuestionIds.has(questionId)) {
        return res.status(400).json({
          success: false,
          message: "Duplicate question submissions are not allowed"
        });
      }
      submittedQuestionIds.add(questionId);

      const question = questionMap.get(questionId);
      if (!question) {
        return res.status(400).json({
          success: false,
          message: "Invalid question ID"
        });
      }

      if (!question.options.some((option) => option.optionId === selectedOptionId)) {
        return res.status(400).json({
          success: false,
          message: "Invalid option ID"
        });
      }

      if (question.correctOptionId === selectedOptionId) {
        score += 1;
      }
    }

    const attempt = await QuizAttempt.create({
      studentId: req.user._id,
      quizId: quiz._id,
      answers: answers.map((answer) => ({
        questionId: answer.questionId.trim(),
        selectedOptionId: answer.selectedOptionId.trim()
      })),
      score,
      totalQuestions: quiz.questions.length
    });

    return res.status(201).json({
      success: true,
      message: "Quiz submitted successfully",
      data: {
        quizId: quiz._id,
        score: attempt.score,
        totalQuestions: attempt.totalQuestions,
        submittedAt: attempt.createdAt
      }
    });
  } catch (error) {
    if (error?.code === 11000) {
      return res.status(409).json({
        success: false,
        message: "You have already submitted this quiz"
      });
    }

    console.error("SUBMIT QUIZ ERROR:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};

const uploadQuiz = async (req, res) => {
  try {
    if (!req.user || !req.user._id) {
      return res.status(401).json({
        success: false,
        message: "You must be logged in"
      });
    }

    if (!hasQuizPermission(req)) {
      return res.status(403).json({
        success: false,
        message: "You do not have permission to manage quizzes"
      });
    }

    const { title, targetClass, questions, status = "draft" } = req.body || {};

    if (!isNonEmptyString(title)) {
      return res.status(400).json({
        success: false,
        message: "Quiz title is required"
      });
    }

    if (!isNonEmptyString(targetClass)) {
      return res.status(400).json({
        success: false,
        message: "Target class is required"
      });
    }

    if (!QUIZ_STATUSES.has(status)) {
      return res.status(400).json({
        success: false,
        message: "Status must be draft or published"
      });
    }

    const questionError = validateQuestions(questions);
    if (questionError) {
      return res.status(400).json({
        success: false,
        message: questionError
      });
    }

    if (!mongoose.isValidObjectId(req.user._id)) {
      console.error("QUIZ UPLOAD ERROR: authenticated user has invalid ID");
      return res.status(401).json({
        success: false,
        message: "Invalid authenticated user"
      });
    }

    const quiz = await Quiz.create({
      title: title.trim(),
      targetClass: targetClass.trim(),
      createdBy: req.user._id,
      questions: questions.map((question) => ({
        questionId: question.questionId.trim(),
        questionText: question.questionText.trim(),
        options: question.options.map((option) => ({
          optionId: option.optionId.trim(),
          text: option.text.trim()
        })),
        correctOptionId: question.correctOptionId.trim()
      })),
      status
    });

    return res.status(201).json({
      success: true,
      message: "Quiz uploaded successfully",
      data: getQuizMetadata(quiz)
    });
  } catch (error) {
    if (error.name === "ValidationError") {
      return res.status(400).json({
        success: false,
        message: "Invalid quiz data"
      });
    }

    console.error("QUIZ UPLOAD ERROR:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};

module.exports = {
  uploadQuiz,
  validateQuestions,
  getQuizzes,
  getQuiz,
  submitQuiz
};