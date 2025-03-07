import db from '../utils/db.js';
import moment from 'moment';

const editorService = {
    async countNewsStatusByUserId(Id_user, date) {
        try {

            const result = await db('News')
                .join('SubCategory', 'News.Id_SubCategory', 'SubCategory.Id_SubCategory')
                .join('Category', 'SubCategory.Id_Category', 'Category.Id_Category')
                .join('Editor', 'Category.Id_Category', 'Editor.Id_Category')
                .join('Status_Of_News', 'News.Id_Status', 'Status_Of_News.Id_Status')
                .where('Editor.Id_User', Id_user)
                .andWhere(db.raw('DATE(News.Date) = ?', [date]))  // filter by the specific date
                .select('Status_Of_News.Title_Status as title_status')
                .count('News.Id_News as count')
                .groupBy('Status_Of_News.Title_Status')  // Group by status
                .orderBy('title_status');  // Order by status or as needed

            // If there are no results for a specific title_status, we manually return that as 0
            const statusList = ['Đồng ý', 'Chưa duyệt', 'Chưa đạt', 'Từ chối'];; // Example of all possible status values
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
    async findEditor(id_user) {
        try {
            const result = await db('Editor').where('Id_User', id_user).first();
            return result.Id_Editor;
        }
        catch (error) {
            console.error("Lỗi khi tìm kiếm editor:", error);
        }
    },
    async findAllPost(editorId) {
        try {
            const editor = await db('Editor').where('Id_Editor', editorId).first();
            if (!editor) return [];

            const { Id_Category } = editor;

            const subCategories = await db('SubCategory').where('Id_Category', Id_Category).select('Id_SubCategory');

            const posts = await db('News')
                .join('Writer', 'News.Id_Writer', '=', 'Writer.Id_Writer')
                .whereIn('Id_SubCategory', subCategories.map(sub => sub.Id_SubCategory))
                .select('News.*', 'Writer.Pen_Name');

            const formattedPosts = posts.map(post => ({
                ...post,
                Premium: post.Premium.equals(Buffer.from([1]))
            }));

            return formattedPosts;
        } catch (error) {
            console.error("Lỗi khi tìm kiếm bài viết của editor:", error);
            return [];
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
    async updateNewsPremium(id_news, newPremiumValue) {
        try {
            await db('News')
                .where('Id_News', id_news)
                .update({ Premium: newPremiumValue });
        } catch (error) {
            console.error("Lỗi khi cập nhật trạng thái Premium:", error);
        }
    },



    async findPostPerMonth() {
        try {
            const result = await db('editor').count('Id_News as total');
            return result[0].total
        }
        catch (error) {
            console.error("Lỗi khi đếm số lượng bản ghi:", error);
        }
    },
    async getRejectedArticles() {
        try {
            const result = await db('News')
                .join('Editor_Check_News', 'News.Id_News', '=', 'Editor_Check_News.Id_News')
                .join('Writer', 'News.Id_Writer', '=', 'Writer.Id_Writer')
                .select('News.*', 'Editor_Check_News.Reason', 'Writer.Pen_Name')
                .where('News.Id_Status', 'STS0004');
            return result;
        } catch (error) {
            console.error("Lỗi khi lấy bài viết bị từ chối:", error);
            throw error;
        }
    },
    async addRejectionReason(id_news, reason, id_editor, date_feedback) {
        try {
            await db('Editor_Check_News').insert({
                Id_News: id_news,
                Reason: reason,
                Id_Editor: id_editor,
                Date_feedback: date_feedback,
            });
        } catch (error) {
            console.error("Lỗi khi thêm lý do từ chối:", error);
            throw error;
        }
    },

    async updateNewsStatus(id_news, new_status) {
        try {
            await db('News')
                .where('Id_News', id_news)
                .update({ Id_Status: new_status });
        } catch (error) {
            console.error("Lỗi khi cập nhật trạng thái bài viết:", error);
            throw error;
        }
    },




    async getWritersWithStatusCount(editorId) {
        try {
            const editor = await db('Editor').select('Id_Category').where('Id_Editor', editorId).first();

            if (!editor) {
                throw new Error('Editor không tồn tại');
            }

            const result = await db('Writer')
                .leftJoin('News', 'Writer.Id_Writer', '=', 'News.Id_Writer')
                .select('Writer.Id_Writer', 'Writer.Pen_Name')
                .count({ approved: db.raw('CASE WHEN News.Id_Status = "STS0001" THEN 1 END') })
                .count({ pending: db.raw('CASE WHEN News.Id_Status = "STS0002" THEN 1 END') })
                .count({ not_passed: db.raw('CASE WHEN News.Id_Status = "STS0003" THEN 1 END') })
                .count({ rejected: db.raw('CASE WHEN News.Id_Status = "STS0004" THEN 1 END') })
                .where('Writer.Id_Category', editor.Id_Category) // Lọc Writer theo Id_Category của Editor
                .groupBy('Writer.Id_Writer', 'Writer.Pen_Name');

            return result;
        } catch (error) {
            console.error("Lỗi khi lấy thông tin Writer:", error);
            throw error;
        }
    },
    async getUserById(id_user) {
        try {
            const user = await db('User')
                .where('Id_User', id_user)
                .first();

            if (!user) {
                throw new Error('Người dùng không tồn tại');
            }

            return user;
        } catch (error) {
            console.error("Lỗi khi lấy thông tin người dùng:", error);
            throw error;
        }
    },
    async updateUser(id_user, updatedUser) {
        try {
            await db('User')
                .where('Id_User', id_user)
                .update(updatedUser);
        } catch (error) {
            console.error("Lỗi khi cập nhật thông tin người dùng:", error);
            throw error;
        }
    },
    async updateNewsDate(id_news, date) {
        try {
            await db('News')
                .where('Id_News', id_news)
                .update({ Date: moment(date).format('YYYY-MM-DD HH:mm:ss') }); // Cập nhật ngày
        } catch (error) {
            console.error("Lỗi khi cập nhật ngày bài viết:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },



    // 25/12/2024
    async findNewsByIdFullAttribute(id_news) {
        try {
            const news = await db('News').where('Id_News', id_news).first(); // Lấy thông tin bài viết
            if (news) {
                news.Premium = news.Premium.equals(Buffer.from([1]));
            }
            return news; // Trả về thông tin bài viết
        } catch (error) {
            console.error('Lỗi khi lấy thông tin bài viết:', error);
            throw error; // Ném lỗi để xử lý ở nơi khác
        }
    },

    async updateNews(id_news, updatedNews) {
        try {
            updatedNews.Premium = updatedNews.Premium ? 1 : 0; // Chuyển đổi boolean thành BIT

            // Cập nhật thông tin bài viết trong bảng News
            await db('News')
                .where('Id_News', id_news)
                .update(updatedNews);



        } catch (error) {
            console.error('Lỗi khi cập nhật bài viết:', error);
            throw error; // Ném lỗi để xử lý ở nơi khác
        }
    },
    async findWriterByNewsId(id_news) {
        try {
            const result = await db('News')
                .where('Id_News', id_news)
                .select('Id_Writer')
                .first();
            
            return result ? result.Id_Writer : null; // Trả về Id_Writer nếu tìm thấy, null nếu không tìm thấy
        } catch (error) {
            console.error('Lỗi khi lấy Id_Writer từ bài viết:', error);
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


}

export default editorService