import db from '../utils/db.js';

const newsService = {
    async findById(newsId) {
        try {
            const news = await db('News as n')
                .join('SubCategory as s', 'n.Id_SubCategory', 's.Id_SubCategory')
                .join('Category as c', 's.Id_Category', 'c.Id_Category')
                .join('Writer as w', 'n.Id_Writer', 'w.Id_Writer')
                .join('User as u', 'w.Id_User', 'u.Id_User')
                .where('n.Id_News', newsId)
                .andWhere('n.Id_Status', 'STS0001')
                .select(
                    'n.*',
                    's.Name as SubCategoryName',
                    'c.Name as CategoryName',
                    'u.Name as WriterName'
                )
                .first();
            
            return news;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    async getNewsTags(newsId) {
        try {
            const tags = await db('News_Tag as nt')
                .join('Tag as t', 'nt.Id_Tag', 't.Id_Tag')
                .where('nt.Id_News', newsId)
                .select('t.Name as TagName');
            return tags;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    async getCommentsByNewsId(newsId) {
        try {
            const comments = await db('Comment as c')
                .join('User as u', 'c.Id_User', 'u.Id_User')
                .where('c.Id_News', newsId)
                .select('c.Id_Comment', 'u.Name as UserName', 'c.Comment', 'c.Time')
                .orderBy('c.Time', 'asc');
            return comments;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    // async addComment({ newsId, userId, comment, commentId }) {
    //     try {
    //         await db('Comment').insert({
    //             Id_Comment: commentId,
    //             Id_News: newsId,
    //             Id_User: userId,
    //             Comment: comment,
    //             Time: new Date()
    //         });
    //     } catch (error) {
    //         console.error('Database error:', error);
    //         throw error;
    //     }
    // },

    async getRelatedNewsByTag(newsId) {
        try {
            // Lấy các tag của bài viết hiện tại
            const tags = await db('News_Tag as nt')
                .where('nt.Id_News', newsId)
                .select('nt.Id_Tag');

            // console.log('Tags for current news:', tags); // Log các tag

            // Lấy các bài viết có cùng tag
            const relatedNews = await db('News as n')
                .join('News_Tag as nt', 'n.Id_News', 'nt.Id_News')
                .whereIn('nt.Id_Tag', tags.map(tag => tag.Id_Tag)) // Chuyển đổi thành mảng ID tag
                .andWhere('n.Id_News', '!=', newsId) // Loại bỏ bài viết hiện tại
                .select('n.*')
                .groupBy('n.Id_News')
                .orderByRaw('COUNT(nt.Id_Tag) DESC') // Ưu tiên bài viết có nhiều tag
                .limit(10);

            // console.log('Related news:', relatedNews); // Log các bài viết liên quan

            return relatedNews;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    async getTopViewedNewsInCategory(subCategoryId, newsId) {
        try {
            // Lấy Id_Category từ SubCategory
            const category = await db('SubCategory')
                .where('Id_SubCategory', subCategoryId)
                .select('Id_Category')
                .first();

            if (!category) {
                return []; // Nếu không tìm thấy danh mục, trả về mảng rỗng
            }

            // Tạo biến cho một tháng trước
            const oneMonthAgo = new Date();
            oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);

            // Sử dụng Id_Category để lấy các bài viết trong vòng 1 tháng qua
            const topNews = await db('News as n')
                .join('SubCategory as sc', 'n.Id_SubCategory', 'sc.Id_SubCategory') // Join với bảng SubCategory
                .where('sc.Id_Category', category.Id_Category) // Lọc theo danh mục
                .andWhere('n.Id_News', '!=', newsId) // Loại bỏ bài viết hiện tại
                .andWhere('n.Date', '>=', oneMonthAgo) // Lọc theo thời gian
                .andWhere('n.Id_Status', 'STS0001') // Thêm điều kiện này
                .orderBy('n.Views', 'desc') // Sắp xếp theo lượt xem
                .select('n.*')
                .limit(10); // Giới hạn số lượng bài viết

            return topNews;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    async getTopViewedNewsLastWeek() {
        try {
            const oneWeekAgo = new Date();
            oneWeekAgo.setDate(oneWeekAgo.getDate() - 7); // Tính ngày 7 ngày trước

            const topNews = await db('News as n')
                .where('n.Date', '>=', oneWeekAgo) // Lọc theo thời gian
                .andWhere('n.Id_Status', 'STS0001') // Lọc theo trạng thái
                .orderBy('n.Views', 'desc') // Sắp xếp theo lượt xem
                .select('n.*')
                .limit(3); // Giới hạn số lượng bài viết

            return topNews;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    async incrementViewCount(newsId) {
        try {
            await db('News')
                .where('Id_News', newsId)
                .increment('Views', 1); // Tăng giá trị Views lên 1
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    }
};

export default newsService;
