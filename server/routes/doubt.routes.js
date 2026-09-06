const express = require('express');
const router = express.Router();
const requireLogin = require('../middlewares/requireLogin');
const authorize = require('../middlewares/authorize');
const doubtController = require('../controllers/doubt.controller');

//routes for students
router.post('/createdoubt', requireLogin, doubtController.createDoubt);
router.get('/mydoubts', requireLogin, doubtController.getmyDoubts);

//routes for lead and admin 
// Only users with DOUBT_MANAGER permissions (R&D Lead, Admin) can access these
router.get('/open', requireLogin, authorize('REPLY_DOUBTS'), doubtController.getOpenDoubts);
router.get('/closed', requireLogin, authorize('REPLY_DOUBTS'), doubtController.getClosedDoubts);

router.get('/:id', requireLogin, doubtController.getDoubtDetails);
router.get('/:id/messages', requireLogin, doubtController.getDoubtMessages);
router.post('/:id/messages', requireLogin, doubtController.addMessage);


router.post('/:id/reply', requireLogin, authorize('REPLY_DOUBTS'), doubtController.addReply);
router.put('/:id/resolve', requireLogin, authorize('RESOLVE_DOUBTS'), doubtController.resolveDoubt);

module.exports = router;