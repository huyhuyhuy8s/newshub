import db from '../utils/db.js';
import bcrypt from 'bcryptjs';

export default {
    async add(entity) {
        try {
            // Hash password trước khi lưu
            const salt = bcrypt.genSaltSync(10);
            entity.Password = bcrypt.hashSync(entity.Password, salt);

            // Thêm user mới vào database
            const ids = await db('User').insert(entity);
            return ids[0];
        } catch (error) {
            console.error('Registration error:', error);
            throw error;
        }
    }
}