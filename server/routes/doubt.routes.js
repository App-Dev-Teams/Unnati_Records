const express = require('express');
const router = express.Router();
const requireLogin = require('../middlewares/requireLogin');
const doubtController = require('../controllers/doubt.controller');

//routes for students
router.post('/createdoubt', requireLogin, doubtController.createDoubt);
router.get('/mydoubts', requireLogin, doubtController.getmyDoubts);

//routes for lead and admin 
router.get('/open', requireLogin, doubtController.getOpenDoubts);
router.get('/closed', requireLogin, doubtController.getClosedDoubts);

router.get('/:id', requireLogin, doubtController.getDoubtDetails);
router.get('/:id/messages', requireLogin, doubtController.getDoubtMessages);
router.post('/:id/messages', requireLogin, doubtController.addMessage);


router.post('/:id/reply', requireLogin, doubtController.addReply);
router.put('/:id/resolve', requireLogin, doubtController.resolveDoubt);

module.exports = router;