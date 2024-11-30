import express from 'express';
import LoginService from '../services/Login.service.js';
import { dirname } from 'path';
import { fileURLToPath } from 'url';

const router = express.Router();

// Route xử lý đăng nhập

router.post('/login', async function (req, res) {
 

     const { email, password } = req.body;

    if (!email || !password) {
        return res.redirect('/login?error=Missing email or password');
    }

    try {
        const user = await LoginService.findUserByEmailAndPassword(email, password);

        if (user) {
            return res.redirect('/home');
        } else {
            // Nếu không tìm thấy user, chuyển hướng đến login với thông báo lỗi
            res.redirect('/login?error=Invalid email or password');
        }
    } catch (error) {
        // Lỗi server
        res.redirect('/login?error=Server error, please try again later');
    }


});

export default router;
