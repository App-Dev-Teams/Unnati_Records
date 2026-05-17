const USER = require("../models/user.model");

const getAllUsers = async (req, res) => {
  try {
    const users = await USER.find({}, "name email role");

    return res.status(200).json({
      success: true,
      count: users.length,
      data: users
    });
  } catch (error) {
    console.error("GET USERS ERROR:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};


// Get users (all volunteers / program wise)
const getUsersByProgram = async (req, res) => {
  try {
    const { program } = req.query;

    let users;

    if (program) {
      // specific program users
      users = await USER.find({
        program: program,
      }).select("-password");
    } else {
      // all users
      users = await USER.find()
        .select("-password");
    }

    return res.status(200).json({
      count: users.length,
      users,
    });

  } catch (err) {
    console.error(err);

    return res.status(500).json({
      message: "Server Error",
    });
  }
};


module.exports = { getAllUsers,getUsersByProgram };
