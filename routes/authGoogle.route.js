import express from 'express';
import moment from 'moment';

import passport from 'passport';
import accountService from '../services/account.service.js';
const router = express.Router();
router.get(
    "/google/callback",
    passport.authenticate("google", { failureRedirect: "/account/login" }),
    async (req, res) => {
        const googleUser = req.user;
        // Kiểm tra và lấy thông tin người dùng từ DB (nếu cần)
        const user = await accountService.findOrCreateGoogleUser(googleUser);
        
        if (!user) {
            return res.render("vwAccount/login", {
                layout: "account",
                error_message: "Không thể đăng nhập bằng Google. Vui lòng thử lại.",
            });
        }

        // Lấy vai trò và quyền của người dùng
        const roles = await accountService.getUserRoles(user.Id_User);

        // Lưu thông tin vào session
        req.session.auth = true;
        req.session.authUser = {
            ...user,
            ...roles,
        };
        // Kiểm tra xem người dùng có phải là subscriber không
        const subscriber = await accountService.getSubscriberInfoByUserId(user.Id_User);
        req.session.isSubscriber = !!subscriber;

        res.redirect("/");
    }
);



export default router;
