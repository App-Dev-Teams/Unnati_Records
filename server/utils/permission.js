//==========Groups============================
const groups = {
  DOUBT_MANAGER: [
    "VIEW_DOUBTS",
    "REPLY_DOUBTS",
    "RESOLVE_DOUBTS"
  ],

  ATTENDANCE_MANAGER: [
    "MARK_ATTENDANCE",
    //"UPDATE_ATTENDANCE"
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

  "JS-Public Relations": [
    "VIEW_DOUBTS"
  ],

  "JS-Technical": [
    "VIEW_DOUBTS"
  ],

  "Finance Lead": [
    "VIEW_DOUBTS"
  ],

  "Video Editing Lead": [
    "VIEW_DOUBTS"
  ],

  "Outreach Lead": [
    "VIEW_DOUBTS"
  ],

  "Social Media Lead": [
    "VIEW_DOUBTS"
  ],

  "Membership Lead": [
    "VIEW_DOUBTS"
  ],

  "Design Lead": [
    "VIEW_DOUBTS"
  ],

  "Operations Lead": [
    "VIEW_DOUBTS",
    ...groups.ATTENDANCE_MANAGER
  ],

  "DigiXplore Lead": [
    "VIEW_DOUBTS",
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER
  ],

  "Netritva Lead": [
    "VIEW_DOUBTS",
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER
  ],

  "Akshar Lead": [
    "VIEW_DOUBTS",
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER
  ],

  "JS-Program": [
    "VIEW_DOUBTS",
    ...groups.RESOURCE_MANAGER
  ],

  "R&D Lead": [
    ...groups.DOUBT_MANAGER
  ],

  "Volunteer": [
    "VIEW_DOUBTS"
  ],

  "volunteer": [
    "VIEW_DOUBTS"
  ],
};

module.exports = rolePermissions;