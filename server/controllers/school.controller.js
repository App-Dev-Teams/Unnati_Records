const schoolModel = require("../models/school.model");

// GET- all schools
const getSchools = async (req, res) => {
  try {
    const schools = await schoolModel.find();

    return res.status(200).json({
      success: true,
      message: "Schools fetched successfully",
      data: schools,
    });

  } catch (error) {
    console.log("GET SCHOOLS ERROR:", error);

    return res.status(500).json({
      success: false,
      message: `Internal server error ${error.message}`,
    });
  }
};

module.exports = {
  getSchools,
};