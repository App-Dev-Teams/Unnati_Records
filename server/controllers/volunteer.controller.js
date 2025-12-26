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

module.exports = { getAllUsers };
