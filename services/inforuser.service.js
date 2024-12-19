import db from '../utils/db.js';

const inforUserService = {
    async getUserInfo(userId) {
        try {
            // Truy vấn thông tin người dùng dựa trên Id_User
            const user = await db('User').where('Id_User', userId).first();
            // Truy vấn thông tin Subcriber dựa trên Id_User
            const subcriber = await db('Subcriber').where('Id_User', userId).first();

            // Trả về thông tin người dùng và Subcriber
            return { ...user, subcriber }; 
        } catch (error) {
            console.error('Database error:', error);
            throw error; // Ném lại lỗi để xử lý ở nơi gọi phương thức này
        }
    },

    async updateUser(userId, updatedData) {
        try {
            await db('User').where('Id_User', userId).update(updatedData);
        } catch (error) {
            console.error('Error updating user in database:', error);
            throw error;
        }
    }
};

export default inforUserService;
