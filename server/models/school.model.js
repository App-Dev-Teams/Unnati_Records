const mongoose = require("mongoose");

const schoolSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
  },
 {
    collection: "Schools"
 },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("School", schoolSchema);