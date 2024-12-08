// import db from '../utils/db.js';
// import bcrypt from 'bcryptjs';

// export default {
//     async add(entity) {
//         try {
//             // Hash password trước khi lưu
//             const salt = bcrypt.genSaltSync(10);
//             entity.Password = bcrypt.hashSync(entity.Password, salt);

//             // Thêm user mới vào database
//             const ids = await db('User').insert(entity);
//             return ids[0];
//         } catch (error) {
//             console.error('Registration error:', error);
//             throw error;
//         }
//     }
// }

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
            return ids[0];
        } catch (error) {
            console.error('Registration error:', error);
            throw error;
        }
    }
}