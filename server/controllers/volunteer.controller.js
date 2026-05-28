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
//it is for admin app
const assignRole=async(req,res) => {
  try {
    const { userId, role } = req.body;
    if(!userId||!role) {
      return res.status(400).json({
        message: "userId and role are required"
      });
    }
    const validRoles=[ 
      "Admin",
      "Finance Lead",
      "JS-Program",
      "JS-Public Relations",
      "JS-Technical",
      "DigiXplore Lead",
      "Akshar Lead",
      "Netritva Lead",
      "R&D Lead",
      "Operations Lead",
      "Social Media Lead",
      "Design Lead",
      "Video Editing Lead",
      "Outreach Lead",
      "Membership Lead",
    
    ];
      if(!validRoles.includes(role)){
        return res.status(400).json({
          message: "Invalid role. Valid roles are: " + validRoles.join(", ")
        });
      }
      const updatedUser=await USER.findByIdAndUpdate(
        userId,
        {role:role},
        {
          new:true, runValidators:true        }
      ).select("-password");
      if(!updatedUser){
        return res.status(404).json({
          message: "User not found"
        });
      }
      return res.status(200).json({
        success:true,
        message: "Role assigned successfully",
        data: updatedUser
      });
  } catch (error) {
    console.error("ASSIGN ROLE ERROR:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
}


module.exports = { getAllUsers,getUsersByProgram, assignRole };
