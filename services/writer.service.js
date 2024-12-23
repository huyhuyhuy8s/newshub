import db from '../utils/db.js';
import moment from 'moment';

const writerService = {
    async findStatus(id_status) {
        try {
            return await db('status_of_news').where('Id_Status', id_status).first();
        }
        catch (error) {
            console.error("status not found", error);
        }
    },
    async findWriter(id_user) {
        try {
            const writer = await db('writer').where('Id_User', id_user).first();
            return writer ? writer.Id_Writer : null;;
        }
        catch (error) {
            console.error("Khong tim thay writer");
        }
    },

    async getUserById(id_user) {
        try {
            const user = await db('User')
                .where('Id_User', id_user)
                .first(); // Lấy bản ghi đầu tiên

            if (!user) {
                throw new Error('Người dùng không tồn tại');
            }

            return user; // Trả về thông tin của người dùng
        } catch (error) {
            console.error("Lỗi khi lấy thông tin người dùng:", error);
            throw error; // Ném lỗi để xử lý ở nơi khác
        }
    },
    async addData(news) {
        try {
            const lastNews = await db('News')
                .orderBy('Id_News', 'desc')
                .first();

            // Tạo ID mới
            let newId;
            if (!lastNews) {
                newId = 'NEWS0001';
            } else {
                const lastNumber = parseInt(lastNews.Id_News.slice(4));
                newId = `NEWS${String(lastNumber + 1).padStart(4, '0')}`;
            }

            news.Id_News = newId;
            const currentDate = moment();
            news.Date = currentDate.toDate();
            news.Views = 0;

            // console.log(news);
            // console.log(news.Content);
            const ret = await db('News').insert(news);
            // console.log(ret.Content);
            // console.log(ret, 'succ');
        }
        catch (error) {
            console.error(error);
        }
    },
    async findAllPost(id_writer) {
        const posts = await db("News").where('Id_Writer', id_writer);
    
        // Chuyển đổi giá trị Premium từ BIT sang boolean
        return posts.map(post => ({
            ...post,
            Premium: post.Premium.equals(Buffer.from([1])) // Chuyển đổi BIT thành boolean
        }));
    },
    async updateUser(id_user, updatedUser) {
        try {
            await db('User')
                .where('Id_User', id_user)
                .update(updatedUser); // Cập nhật thông tin người dùng
        } catch (error) {
            console.error("Lỗi khi cập nhật thông tin người dùng:", error);
            throw error; // Ném lỗi để xử lý ở nơi khác
        }
    },
    async getRejectionReason(id_news) {
        try {
            const result = await db('Editor_Check_News')
                .select('Reason')
                .where('Id_News', id_news)
                .first(); // Lấy kết quả đầu tiên
    
            return result ? result.Reason : null; // Trả về lý do nếu có
        } catch (error) {
            console.error("Lỗi khi lấy lý do từ chối:", error);
            throw error; // Ném lỗi để xử lý ở nơi khác
        }
    },
    async findNewsById(id_news) {
        try {
            const result = await db('News')
                .join('Writer', 'News.Id_Writer', '=', 'Writer.Id_Writer')
                .where('News.Id_News', id_news)
                .select('News.*', 'Writer.Pen_Name')
                .first();

            if (result) {
                result.Premium = result.Premium.equals(Buffer.from([1]));
                return result;
            } else {
                return null;
            }
        } catch (error) {
            console.error("Lỗi khi tìm kiếm bài viết:", error);
        }
    },

}
export default writerService