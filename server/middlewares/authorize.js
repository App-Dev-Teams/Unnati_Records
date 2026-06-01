const rolePermissions = require("../utils/permission");


const authorize = (permission) => {

   return (req, res, next) => {

      if (!req.user) {
         return res.status(401).json({
            message: "Unauthorized"
         });
      }

      const userRole = req.user.role;

      const permissions =
         rolePermissions[userRole] || [];

      if (!permissions.includes(permission)) {

         return res.status(403).json({
            message: "Access denied"
         });
      }

      next();
   };
};

module.exports = authorize;