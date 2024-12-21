import db from '../utils/db.js';

const inforUserService = {
    async getUserInfo(userId) {
        try {
            // Truy vấn thông tin người dùng dựa trên Id_User
            const user = await db('User').where('Id_User', userId).first();
            // Truy vấn thông tin Subcriber dựa trên Id_User
            const subcriber = await db('Subcriber').where('Id_User', userId).first();
            const administrator = await db('Administrator').where('Id_User', userId).first();
            const writer = await db('Writer').where('Id_User', userId).first();
            const editor = await db('Editor').where('Id_User', userId).first();

            // Chuyển đổi Request từ Buffer sang số
            if (subcriber && subcriber.Request) {
                subcriber.Request = subcriber.Request[0]; // Lấy giá trị đầu tiên từ Buffer
            }

            // Trả về thông tin người dùng và Subcriber
            return { ...user, subcriber, administrator, writer, editor };
        } catch (error) {
            console.error('Database error:', error);
            throw error; // Ném lại lỗi để xử lý ở nơi gọi phương thức này
        }
    },

    async updateUser(userId, updatedData) {
        try {

            // Xóa email khỏi updatedData nếu có
            delete updatedData.Email;
            
            await db('User').where('Id_User', userId).update(updatedData);
        } catch (error) {
            console.error('Error updating user in database:', error);
            throw error;
        }
    },
    async renewSubscription(userId) {
        try {
            await db('Subcriber')
                .where('Id_User', userId)
                .update({ Request: 1 }); // Cập nhật Request thành 1
        } catch (error) {
            console.error('Error updating subscription request:', error);
            throw error;
        }
    }
};

export default inforUserService;
