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
    "MANAGE_QUIZZES",
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER,
    ...groups.DOUBT_MANAGER
  ],

  "JS-Public Relations": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS"
  ],

  "JS-Technical": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS"
  ],

  "Finance Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS"
  ],

  "Video Editing Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS"
  ],

  "Outreach Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS"
  ],

  "Social Media Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS"
  ],

  "Membership Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS"
  ],

  "Design Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS"
  ],

  "Operations Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS",
    ...groups.ATTENDANCE_MANAGER
  ],

  "DigiXplore Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS",
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER
  ],

  "Netritva Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS",
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER
  ],

  "Akshar Lead": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS",
    ...groups.ATTENDANCE_MANAGER,
    ...groups.RESOURCE_MANAGER
  ],

  "JS-Program": [
    "MANAGE_QUIZZES",
    "VIEW_DOUBTS",
    ...groups.RESOURCE_MANAGER
  ],

  "R&D Lead": [
    "MANAGE_QUIZZES",
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