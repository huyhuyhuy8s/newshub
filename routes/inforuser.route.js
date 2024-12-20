import express from 'express';
import bcrypt from 'bcryptjs';
import moment from 'moment';
import inforUserService from '../services/inforuser.service.js';

const router = express.Router();

// Route để lấy thông tin người dùng
router.get('/inforuser', async (req, res) => {
    const { id_user, name, email, birthday } = req.query; 
    if (!req.session.auth) {
        return res.redirect('/account/login');
    }

    try {
        const userInfo = await inforUserService.getUserInfo(req.session.authUser.Id_User);
        if (!userInfo) {
            return res.status(404).send('User not found');
        }
        res.render('vwInforUser/inforuser', { userInfo, layout: false, id_user, name, email, birthday });
    } catch (error) {
        console.error('Error fetching user info:', error);
        res.status(500).send('Internal Server Error');
    }
});

// Route để cập nhật thông tin người dùng
router.post('/update', async (req, res) => {
    const { name, email, dob, password } = req.body;
    console.log('name:', name)

    try {
        if (!req.session.auth) {
            return res.status(401).send('Unauthorized');
        }

        const userId = req.session.authUser.Id_User;
        const updatedUser = {};

        // Cập nhật các trường nếu có giá trị
        if (name) updatedUser.Name = name;
        if (dob) updatedUser.Birthday = moment(dob).format('YYYY-MM-DD');

        // Chỉ mã hóa mật khẩu nếu có giá trị
        if (password) {
            const salt = bcrypt.genSaltSync(10);
            updatedUser.Password = bcrypt.hashSync(password, salt); // Mã hóa mật khẩu
        }

        // Kiểm tra xem có trường nào để cập nhật không
        if (Object.keys(updatedUser).length === 0) {
            return;
        }

        await inforUserService.updateUser(userId, updatedUser);
        req.session.authUser = { ...req.session.authUser, ...updatedUser };


        res.redirect(`/inforuser/inforuser?id_user=${userId}&name=${name}&email=${email}&birthday=${dob}`);
    } catch (error) {
        console.error('Error updating user info:', error);
        res.status(500).send('Có lỗi xảy ra, vui lòng thử lại! (route)'); // Trả về lỗi
    }
});









export default router;
