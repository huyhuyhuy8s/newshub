import express from 'express';
import bcrypt from 'bcryptjs';
import moment from 'moment';
import session from 'express-session';
import loginService from '../services/login.service.js';
import registerService from '../services/register.service.js';
import nodemailer from 'nodemailer';



const router = express.Router();

import { fileURLToPath } from 'url';
import { dirname, join } from 'path'
const __dirname = dirname(fileURLToPath(import.meta.url));
router.use(express.static(join(__dirname, '../static')));
router.use(express.static(join(__dirname, '../imgs')));
// console.log(join(__dirname, '../static'));


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
        const result = await loginService.validateUser(email, password); // Sử dụng loginService để xác thực
        if (result.error) {
            return res.render('vwAccount/login', {
                layout: 'account',
                error_message: result.message
            });
        }

        req.session.auth = true; // Đánh dấu người dùng đã đăng nhập
        req.session.authUser = result.user; // Lưu thông tin người dùng vào session
        //console.log('User logged in:', req.session.authUser); // Log thông tin người dùng
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
        await registerService.add(entity);

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

router.get('/logout', function (req, res) {
    req.session.auth = false;
    req.session.authUser = null;
    req.session.destroy(function(err) {
        res.redirect('/account/login');
    });
});





export default router;