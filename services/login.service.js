import db from '../utils/db.js';
import bcrypt from 'bcryptjs';

export default {
    async validateUser(email, password) {
        try {
            // Tìm user theo email
            const user = await db('User')
                .where('Email', email)
                .first();

            // Nếu không tìm thấy user
            if (!user) {
                return {
                    error: true,
                    message: 'Tài khoản không tồn tại!'
                };
            }

            // Kiểm tra password
            const match = bcrypt.compareSync(password, user.Password);
            if (!match) {
                return {
                    error: true,
                    message: 'Mật khẩu không chính xác!'
                };
            }

            // Nếu đúng, trả về thông tin user (trừ password)
            delete user.Password;
            return {
                error: false,
                user: user
            };

        } catch (error) {
            console.error('Login validation error:', error);
            throw error;
        }
    }
}