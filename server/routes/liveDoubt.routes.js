const express = require('express');
const router = express.Router();
const requireLogin = require('../middlewares/requireLogin');
const liveCtrl = require('../controllers/liveDoubt.controller');

// Student endpoints
router.post('/request', requireLogin, liveCtrl.requestLiveCall);
router.get('/my-status', requireLogin, liveCtrl.checkMyStatus);
router.post('/cancel', requireLogin, liveCtrl.cancelLiveRequest);

// Lead queue and scheduling endpoints
router.get('/queue', requireLogin, liveCtrl.getLiveQueue);
router.put('/:id/schedule', requireLogin, liveCtrl.scheduleLiveCall);
router.post('/:id/start', requireLogin, liveCtrl.startLiveCall);

// End call endpoint (Student or Lead)
router.post('/:id/end', requireLogin, liveCtrl.endLiveCall);

module.exports = router;
