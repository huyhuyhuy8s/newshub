

import db from '../utils/db.js';
import bcrypt from 'bcryptjs';

export default {
    async add(entity) {
        try {
            // Lấy ID user lớn nhất hiện tại
            const lastUser = await db('User')
                .orderBy('Id_User', 'desc')
                .first();

            // Tạo ID mới
            let newId;
            if (!lastUser) {
                // Nếu chưa có user nào
                newId = 'USR0001';
            } else {
                // Lấy số từ ID cuối cùng và tăng lên 1
                const lastNumber = parseInt(lastUser.Id_User.slice(3));
                newId = `USR${String(lastNumber + 1).padStart(4, '0')}`;
            }

            // Gán ID mới vào entity
            entity.Id_User = newId;

            // Hash password trước khi lưu
            const salt = bcrypt.genSaltSync(10);
            entity.Password = bcrypt.hashSync(entity.Password, salt);

            // Thêm user mới vào database
            const ids = await db('User').insert(entity);

            // Tạo Subcriber
            await this.addSubcriber(newId);
            return ids[0];
        } catch (error) {
            console.error('Registration error:', error);
            throw error;
        }
    },


    async addSubcriber(userId) {
        try {
            // Lấy ID Subcriber lớn nhất hiện tại
            const lastSubcriber = await db('Subcriber')
                .orderBy('Id_Subcriber', 'desc')
                .first();

            let newSubcriberId;
            if (!lastSubcriber) {
                newSubcriberId = 'SUBC0001';
            } else {
                const lastNumber = parseInt(lastSubcriber.Id_Subcriber.slice(4));
                newSubcriberId = `SUBC${String(lastNumber + 1).padStart(4, '0')}`;
            }

            const dateRegister = new Date();
            const dateExpired = new Date(dateRegister);
            dateExpired.setDate(dateExpired.getDate() + 7); // Ngày hết hạn là 7 ngày sau

            // Thêm Subcriber vào database
            await db('Subcriber').insert({
                Id_Subcriber: newSubcriberId,
                Id_User: userId,
                Date_register: dateRegister,
                Date_expired: dateExpired
            });
        } catch (error) {
            console.error('Error adding subcriber:', error);
            throw error;
        }
    }
}