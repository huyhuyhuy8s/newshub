import express from 'express';

import moment from 'moment';
import session from 'express-session';

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


router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    try {
        const result = await accountService.validateUser(email, password); // Sử dụng loginService để xác thực
        if (result.error) {
            return res.render('vwAccount/login', {
                layout: 'account',
                error_message: result.message
            });
        }
        const user = result.user; // 20/12
        req.session.auth = true; // Đánh dấu người dùng đã đăng nhập
        req.session.authUser = result.user; // Lưu thông tin người dùng vào session


        const roles = await accountService.getUserRoles(user.Id_User);

        req.session.auth = true;
        req.session.authUser = {
            ...user,
            ...roles // Thêm các quyền vào authUser
        };

        // Kiểm tra xem User có Subscriber không 20/12
        const subscriber = await accountService.getSubscriberInfoByUserId(user.Id_User);
        req.session.isSubscriber = !!subscriber; // true nếu có subscriber, false nếu không



        return res.redirect('/'); // Chuyển hướng đến trang chính
    } catch (error) {
        console.error('Login error:', error);
        return res.render('vwAccount/login', {
            layout: 'account',
            error_message: 'Có lỗi xảy ra, vui lòng thử lại!'
        });
    }
});



router.post('/register', async function (req, res) {
    const { name, email, password, dob } = req.body;

    try {
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
    const { name, email, password, confirm_password, dob } = req.body;
    // Kiểm tra password match
    if (password !== confirm_password) {
        return res.render('vwAccount/register', {
            layout: 'account',
            error_message: 'Mật khẩu nhập lại không khớp!'
        });
    }
    // Tạo OTP
    const otp = accountService.generateOTP();

    // Lưu OTP vào cache
    otpCache[email] = otp;

    // Gửi OTP qua email
    accountService.sendOTP(email, otp);

    // Render trang nhập OTP và gửi email tới người dùng
    res.render('vwAccount/otp', {
        layout: 'account',
        name: name,
        email: email,
        password: password,
        dob: dob,
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

router.get('/logout', function (req, res) {
    req.session.auth = false;
    req.session.authUser = null;
    req.session.destroy(function (err) {
        res.redirect('/account/login');
    });
});


export default router;