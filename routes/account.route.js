import express from 'express';
// import bcrypt from 'bcryptjs';
// import moment from 'moment';
// import session from 'express-session';

import userService from '../services/user.service.js';

const router = express.Router();

router.get('/login', function (req, res) {
    res.render('vwAccount/login');
});

export default router;