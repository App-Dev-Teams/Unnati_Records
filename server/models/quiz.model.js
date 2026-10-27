const mongoose = require("mongoose");

const optionSchema = new mongoose.Schema(
  {
    optionId: {
      type: String,
      required: true,
      trim: true,
      minlength: 1
    },
    text: {
      type: String,
      required: true,
      trim: true,
      minlength: 1
    }
  },
  { _id: false }
);

const questionSchema = new mongoose.Schema(
  {
    questionId: {
      type: String,
      required: true,
      trim: true,
      minlength: 1
    },
    questionText: {
      type: String,
      required: true,
      trim: true,
      minlength: 1
    },
    options: {
      type: [optionSchema],
      required: true,
      validate: [
        {
          validator: (options) => Array.isArray(options) && options.length >= 2,
          message: "Each question must have at least two options"
        },
        {
          validator: (options) => {
            const optionIds = options.map((option) => option.optionId);
            return new Set(optionIds).size === optionIds.length;
          },
          message: "Option IDs must be unique within a question"
        }
      ]
    },
    correctOptionId: {
      type: String,
      required: true,
      trim: true,
      minlength: 1,
      validate: {
        validator: function (correctOptionId) {
          return this.options.some(
            (option) => option.optionId === correctOptionId
          );
        },
        message: "correctOptionId must reference an option in the question"
      }
    }
  },
  { _id: false }
);

const quizSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true,
      minlength: 1
    },
    targetClass: {
      type: String,
      required: true,
      trim: true,
      minlength: 1,
      index: true
    },
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true
    },
    questions: {
      type: [questionSchema],
      required: true,
      validate: [
        {
          validator: (questions) =>
            Array.isArray(questions) && questions.length > 0,
          message: "A quiz must contain at least one question"
        },
        {
          validator: (questions) => {
            const questionIds = questions.map((question) => question.questionId);
            return new Set(questionIds).size === questionIds.length;
          },
          message: "Question IDs must be unique within a quiz"
        }
      ]
    },
    status: {
      type: String,
      enum: ["draft", "published"],
      default: "draft",
      index: true
    }
  },
  { timestamps: true }
);

quizSchema.index({ targetClass: 1, status: 1 });

module.exports = mongoose.model("Quiz", quizSchema);