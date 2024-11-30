import db from '../utils/db.js';

export default {
    async findUserByEmailAndPassword(Email, Password) {
        // Tìm user trong cơ sở dữ liệu
        const user = await db('User')
            .where({ Email, Password }) // So sánh trực tiếp với mật khẩu lưu trong cơ sở dữ liệu
            .first();

        return user || null; // Trả về user nếu tìm thấy, ngược lại trả về null
    },
};
