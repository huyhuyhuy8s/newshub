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
            return await writer ? writer.Id_Writer : null;;
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
            const ret = await db('News').insert(news);
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
    async countNewsStatusByUserId(Id_user, date) {
        try {

            const result = await db('News')
                .join('Writer', 'News.Id_Writer', 'Writer.Id_Writer')
                .join('Status_Of_News', 'News.Id_Status', 'Status_Of_News.Id_Status')
                .where('Writer.Id_User', Id_user)
                .andWhere(db.raw('DATE(News.Date) = ?', [date]))  // filter by the specific date
                .select('Status_Of_News.Title_Status as title_status')
                .count('News.Id_News as count')
                .groupBy('Status_Of_News.Title_Status')  // Group by status
                .orderBy('title_status');  // Order by status or as needed
            // If there are no results for a specific title_status, we manually return that as 0
            const statusList = ['Đồng ý', 'Chưa duyệt', 'Chưa đạt', 'Đã xoá'];; // Example of all possible status values
            const countMap = result.reduce((acc, row) => {
                acc[row.title_status] = row.count;
                return acc;
            }, {});
            const finalResult = statusList.map(status => ({
                title_status: status,
                count: countMap[status] || 0
            }));
            const entity = {
                date: date,
                statuses: finalResult
            };
            return entity;
        }
        catch (error) {
            console.error('Error in countNewsStatusByUserId:', error);
            throw error;
        }
    },





    async getRejectedPosts(id_writer) {
        try {
            const result = await db('News')
                .join('Editor_Check_News', 'News.Id_News', '=', 'Editor_Check_News.Id_News')
                .select('News.*', 'Editor_Check_News.*') // Chỉ lấy thông tin từ bảng News
                .where('News.Id_Status', 'STS0004') // Trạng thái "Từ chối"
                .andWhere('News.Id_Writer', id_writer); // Lọc theo Id_Writer
            return result;
        } catch (error) {
            console.error("Lỗi khi lấy bài viết bị từ chối:", error);
            throw error;
        }
    },

    async getCategoryByWriterId(id_writer) {
        try {
            // Lấy thông tin writer
            const writer = await db('Writer').where('Id_Writer', id_writer).first();
            if (!writer) {
                throw new Error('Writer not found');
            }
    
            // Lấy category dựa trên Id_Category của writer
            const category = await db('Category').where('Id_Category', writer.Id_Category).first();
            return category; // Trả về category
        } catch (error) {
            console.error("Lỗi khi lấy category của writer:", error);
            throw error; // Ném lỗi để xử lý ở nơi khác
        }
    },
    async getSubCategoriesByWriterId(id_writer) {
        try {
            // Lấy Id_Category của writer
            const writer = await db('Writer').where('Id_Writer', id_writer).first();
            if (!writer) {
                throw new Error('Writer not found');
            }
    
            const id_category = writer.Id_Category; // Lấy Id_Category của writer
    
            // Lấy danh sách sub-category dựa trên Id_Category
            const subCategories = await db('SubCategory')
                .where('Id_Category', id_category)
                .select('Id_SubCategory', 'Name'); // Chọn các trường cần thiết
    
            return subCategories;
        } catch (error) {
            console.error("Lỗi khi lấy sub-category của writer:", error);
            throw error; // Ném lỗi để xử lý ở nơi khác
        }
    },
    async findNewsByIdFullAttribute(id_news) {
        try {
            const news = await db('News').where('Id_News', id_news).first(); // Lấy thông tin bài viết
            return news; // Trả về thông tin bài viết
        } catch (error) {
            console.error('Lỗi khi lấy thông tin bài viết:', error);
            throw error; // Ném lỗi để xử lý ở nơi khác
        }
    },

}
export default writerService