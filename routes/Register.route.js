import express from 'express';
import RegisterService from '../services/Register.service.js';
import moment from 'moment';
import bcrypt from 'bcryptjs'
import nodemailer from 'nodemailer'
import randomString from 'randomstring';
import path from 'path'
const router = express.Router();

router.post('/', async (req, res) => {
    const { fullname, email, birthday, password, confirmPassword } = req.body;

   
    // Kiểm tra nếu mật khẩu và mật khẩu xác nhận trùng nhau
    if (password !== confirmPassword) {
        return res.status(400).send('Passwords do not match!');
    }

    // Chuyển đổi ngày sinh
    const ymd_dob = moment(birthday, 'YYYY-MM-DD').format('YYYY/MM/DD');

    const hash_password = bcrypt.hashSync(req.body.raw_password,8)
    // Tạo đối tượng người dùng để lưu vào cơ sở dữ liệu
    const entity = {
        Id_User: fullname,
        Name: fullname,
        Birthday: ymd_dob,
        Email: email,
        Password: hash_password,
    };

    try {
        ()=>{
            res.redirect('/otp')
        }
        // Thêm người dùng vào cơ sở dữ liệu
        await RegisterService.add(entity);
        //res.redirect('/login');  // Sau khi đăng ký thành công, chuyển hướng đến trang login
    } catch (error) {
        console.error('Error during registration:', error);
        res.status(500).send('Error registering user');
    }
});
router
export default router;
