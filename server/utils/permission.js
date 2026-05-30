//==========Groups============================
const groups = {
  DOUBT_MANAGER: [
    "REPLY_DOUBTS",
    "RESOLVE_DOUBTS"
  ],

  ATTENDANCE_MANAGER: [
    "MARK_ATTENDANCE",
    "UPDATE_ATTENDANCE"
  ],

  RESOURCE_MANAGER: [
    "UPLOAD_RESOURCE"
  ]
};


//==============Role permissions==============
const rolePermissions = {

  "Admin": [
    "MANAGE_USERS",
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER,
    ...groups.DOUBT_MANAGER
  ],

  "JS-Public Relations": [],

  "JS-Technical": [],

  "Finance Lead": [],

  "Video Editing Lead": [],

  "Outreach Lead": [],

  "Social Media Lead": [],

  "Membership Lead": [],

  "Design Lead": [],

  "Operations Lead": [
    ...groups.ATTENDANCE_MANAGER
  ],

  "DigiXplore Lead": [
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER
  ],

  "Netritva Lead": [
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER
  ],

  "Akshar Lead": [
    //...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER
  ],

  "JS-Program": [
    ...groups.RESOURCE_MANAGER
  ],

  "R&D Lead": [
    ...groups.DOUBT_MANAGER
  ],
};

module.exports = rolePermissions;