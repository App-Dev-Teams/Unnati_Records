const STUDENT = require("../models/student.model");
const USER = require("../models/user.model");
const ImageKit = require('imagekit');


const imagekit = new ImageKit({
  publicKey: process.env.IMAGEKIT_PUBLIC_KEY,
  privateKey: process.env.IMAGEKIT_PRIVATE_KEY,
  urlEndpoint: process.env.IMAGEKIT_URL_ENDPOINT,
});

// 1. ImageKit authentication for profile pictures
const getProfileImageKitAuth = (req, res) => {
  try {
    const authParams = imagekit.getAuthenticationParameters();

    const folder =
      req.userType === "student"
        ? "/Unnati/student-profile-pics"
        : "/Unnati/volunteer-profile-pics";

    return res.status(200).json({
      ...authParams,
      publicKey: process.env.IMAGEKIT_PUBLIC_KEY,
      folder
    });
  } catch (error) {
    console.error("PROFILE IMAGE AUTH ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Failed to generate profile image authentication"
    });
  }
};


// 2. Save uploaded profile picture URL in MongoDB
const updateProfilePic = async (req, res) => {
  try {
    const { profilePic } = req.body;

    if (!profilePic || typeof profilePic !== "string") {
      return res.status(400).json({
        success: false,
        message: "Profile picture URL is required"
      });
    }

    let parsedUrl;
    let endpointUrl;

    try {
      parsedUrl = new URL(profilePic);
      endpointUrl = new URL(process.env.IMAGEKIT_URL_ENDPOINT);
    } catch {
      return res.status(400).json({
        success: false,
        message: "Invalid image URL"
      });
    }

    if (
      parsedUrl.protocol !== "https:" ||
      parsedUrl.host !== endpointUrl.host ||
      !parsedUrl.pathname.startsWith(endpointUrl.pathname)
    ) {
      return res.status(400).json({
        success: false,
        message: "Please provide a valid ImageKit URL"
      });
    }

    let updatedUser;

    if (req.userType === "student") {
      updatedUser = await STUDENT.findByIdAndUpdate(
        req.user._id,
        { $set: { profilePic } },
        { new: true, runValidators: true }
      ).select("-password");
    } else if (req.userType === "volunteer") {
      updatedUser = await USER.findByIdAndUpdate(
        req.user._id,
        { $set: { profilePic } },
        { new: true, runValidators: true }
      ).select("-password");
    } else {
      return res.status(403).json({
        success: false,
        message: "Unsupported account type"
      });
    }

    if (!updatedUser) {
      return res.status(404).json({
        success: false,
        message: "User not found"
      });
    }

    return res.status(200).json({
      success: true,
      message: "Profile picture updated successfully",
      data: {
        profilePic: updatedUser.profilePic
      }
    });
  } catch (error) {
    console.error("UPDATE PROFILE PIC ERROR:", error);

    return res.status(500).json({
      success: false,
      message: "Failed to update profile picture"
    });
  }
};

module.exports = {
  getProfileImageKitAuth,
  updateProfilePic
};
