import express from 'express';

import moment from 'moment';
import session from 'express-session';

import nodemailer from 'nodemailer';


import userService from '../services/user.service.js';
import accountService from '../services/account.service.js';

const router = express.Router();

var otpCache = {}

import { fileURLToPath } from 'url';
import { dirname, join } from 'path'
const __dirname = dirname(fileURLToPath(import.meta.url));
router.use(express.static(join(__dirname, '../static')));
router.use(express.static(join(__dirname, '../imgs')));



router.get('/login', function (req, res) {
    res.render('vwAccount/login', { layout: 'account' });
});

router.get('/register', function (req, res) {
    res.render('vwAccount/register', { layout: 'account' });
});

router.get('/otp', function (req, res) {
    res.render('vwAccount/otp', { layout: 'account' });
});


router.post('/login', async function (req, res) {
    const { email, password } = req.body;
    console.log('Login attempt:', { email, password });

    try {
        const result = await accountService.validateUser(email, password);
        // console.log('Login result:', result);

        if (result.error) {
            return res.render('vwAccount/login', {
                layout: 'account',
                error_message: result.message
            });
        }

        req.session.auth = true;
        req.session.authUser = result.user;
        res.redirect('/');

    } catch (err) {
        console.error('Login error:', err);
        res.render('vwAccount/login', {
            layout: 'account',
            error_message: 'Có lỗi xảy ra, vui lòng thử lại!'
        });
    }
});



router.post('/register', async function (req, res) {
    const { name, email, password, confirm_password, dob } = req.body;

    try {
        // Kiểm tra password match
        if (password !== confirm_password) {
            return res.render('vwAccount/register', {
                layout: 'account',
                error_message: 'Mật khẩu nhập lại không khớp!'
            });
        }

        // Chuẩn bị dữ liệu để lưu
        const entity = {
            Name: name,
            Email: email,
            Password: password,
            Birthday: moment(dob).format('YYYY-MM-DD'),
            Id_User: 'USR' + Math.floor(Math.random() * 10000).toString().padStart(4, '0')
        };

        // Lưu vào database
        await accountService.add(entity);

        // Chuyển đến trang đăng nhập sau khi đăng ký thành công
        res.redirect('/account/login');

    } catch (err) {
        console.error('Registration error:', err);
        res.render('vwAccount/register', {
            layout: 'account',
            error_message: 'Có lỗi xảy ra, vui lòng thử lại!'
        });
    }
});

router.post('/otp', (req, res) => {
    const { email } = req.body;

    // Tạo OTP
    const otp = accountService.generateOTP();

    // Lưu OTP vào cache
    otpCache[email] = otp;

    // Gửi OTP qua email
    accountService.sendOTP(email, otp);

    // Render trang nhập OTP và gửi email tới người dùng
    res.render('vwAccount/otp', {
        layout: 'account',
        email: email
    });

    // Cài đặt thời gian hết hạn cho cookie OTP
    res.cookie('otpCache', otpCache, { maxAge: 300000, httpOnly: true });
});


router.post('/verifyOTP', (req, res) => {
    // Extract email and otp from the JSON request body
    const { email, otp } = req.body;

    // Kiểm tra xem email có trong cache OTP không
    if (!otpCache.hasOwnProperty(email)) {
        return res.json(false);  // Trả về false nếu không tìm thấy email trong cache
    }

    // Kiểm tra OTP
    if (otpCache[email] === otp.trim()) {
        delete otpCache[email];  // Xóa OTP sau khi xác minh thành công
        return res.json(true);  // Trả về true nếu OTP hợp lệ
    } else {
        return res.json(false);  // Trả về false nếu OTP không hợp lệ
    }
});

// router.get('/login', function (req, res) {
//   res.render('vwAccount/login');
// });

// router.post('/login', async function (req, res) {
//   const user = await userService.findByUsername(req.body.username);
//   if (!user) {
//     return res.render('vwAccount/login', {
//       has_errors: true
//     });
//   }

//   if (!bcrypt.compareSync(req.body.password, user.password)) {
//     return res.render('vwAccount/login', {
//       has_errors: true
//     });
//   }

//   req.session.authUser = user;
//   req.session.auth = true;
//   const retUrl = req.session.retUrl || '/';
//   req.session.retUrl = null;
//   res.redirect(retUrl);
// });

// router.get('/is-available', async function (req, res) {
//   const username = req.query.username;
//   const ret = await userService.findByUsername(username);
//   if (!ret) {
//     return res.json(true);
//   }
//   res.json(false);
// });

// import { isAuth } from '../middleware/auth.node.js';

// router.get('/profile', isAuth, function (req, res) {
//   res.render('vwAccount/profile', {
//     user: req.session.authUser,
//   });
// });

// router.get('/update-password', isAuth, function (req, res) {
//   res.render('vwAccount/update-password', {
//     user: req.session.authUser,
//   });
// });

// router.post('/logout', isAuth, function (req, res) {
//   req.session.auth = false;
//   req.session.authUser = null;
//   req.session.retUrl = null;
//   res.redirect('/');
// })


export default router;