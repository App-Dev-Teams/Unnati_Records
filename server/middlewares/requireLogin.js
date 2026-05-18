
const jwt = require('jsonwebtoken');
const User = require('../models/user.model');
const STUDENT = require('../models/student.model');

module.exports = (req, res, next) => {
    const { authorization } = req.headers;
    if (!authorization) {
        return res.status(401).json({ error: 'You must be logged in' });
    }

    const token = authorization.replace('Bearer ', '');

    jwt.verify(token, process.env.JWT_SECRET, async (err, payload) => {
        if (err) {
            return res.status(401).json({ error: 'you must be logged in' });
        }

        try {
            let user = null;

            // token payload may have either `_id` (volunteer) or `id` (student)
            if (payload && payload._id) {
                user = await User.findById(payload._id);
                req.userType = 'volunteer';
            } else if (payload && payload.id) {
                user = await STUDENT.findById(payload.id);
                req.userType = 'student';
            }

            if (!user) {
                return res.status(401).json({ error: 'you must be logged in' });
            }

            req.user = user;
            next();
        } catch (e) {
            console.error('AUTH MIDDLEWARE ERROR:', e);
            return res.status(500).json({ error: 'Internal server error' });
        }
    });
};