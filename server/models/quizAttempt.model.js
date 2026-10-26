const mongoose = require("mongoose");

const quizAttemptSchema = new mongoose.Schema(
  {
    studentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Student",
      required: true
    },
    quizId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Quiz",
      required: true
    },
    answers: {
      type: [
        {
          _id: false,
          questionId: { type: String, required: true },
          selectedOptionId: { type: String, required: true }
        }
      ],
      required: true
    },
    score: {
      type: Number,
      required: true,
      min: 0
    },
    totalQuestions: {
      type: Number,
      required: true,
      min: 1
    }
  },
  { timestamps: true }
);

quizAttemptSchema.index({ studentId: 1, quizId: 1 }, { unique: true });

module.exports = mongoose.model("QuizAttempt", quizAttemptSchema);
