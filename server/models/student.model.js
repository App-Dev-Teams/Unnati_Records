const mongoose = require("mongoose");

const studentSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true
    },

    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      match: [/^\S+@\S+\.\S+$/, "Invalid email format"]  
    },

    password: {
      type: String,
      required: true,
      minlength: 6,
      select: false   // password by default response me nahi jaayega
    },

    phoneNo: {
      type: String,
      required: true,
      match: [/^[0-9]{10}$/, "Invalid phone number"] //10 digits phone no. otherwise invalid
    },

    studentClass: {  
      type: String,
      required: true
    },

    school: {
      type: String,
      required: true,
      trim: true
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Student", studentSchema);
