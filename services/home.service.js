import db from '../utils/db.js';
import moment from 'moment';

const homeService = {

    async getTopViewedNewsLastWeek() {
        try {
            const oneWeekAgo = new Date();
            oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
            const now = new Date(); 

            const topNews = await db('News as n')
                .where('n.Date', '>=', oneWeekAgo)
                .andWhere('n.Id_Status', 'STS0001') // Lọc theo trạng thái
                .andWhere('n.Date', '<', now) 
                .orderBy('n.Views', 'desc')
                .select('n.*')
                .limit(4); // Lấy 4 bài viết

            return topNews;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    async getTopCategoriesWithLatestNews() {
        try {
            // Lấy 10 category có tổng lượng views cao nhất
            const now = new Date(); 
            const topCategories = await db('Category as c')
                .join('SubCategory as sc', 'c.Id_Category', 'sc.Id_Category')
                .join('News as n', 'sc.Id_SubCategory', 'n.Id_SubCategory')
                .andWhere('n.Date', '<', now) 
                .select('c.Id_Category', 'c.Name as CategoryName') // Chỉ lấy thông tin category
                .groupBy('c.Id_Category')
                .orderByRaw('SUM(n.Views) DESC')
                .limit(10);

            // Lấy bài viết mới nhất trong tất cả sub-category của mỗi category
            const latestNews = await Promise.all(topCategories.map(async (category) => {
                const latest = await db('News as n')
                    .join('SubCategory as sc', 'n.Id_SubCategory', 'sc.Id_SubCategory')
                    .where('sc.Id_Category', category.Id_Category) // Lọc theo category
                    .orderBy('n.Date', 'desc') // Sắp xếp theo ngày giảm dần
                    .first(); // Lấy bài viết mới nhất

                return {
                    ...category,
                    latestNews: latest // Thêm bài viết mới nhất vào kết quả
                };
            }));

            return latestNews; // Trả về danh sách category với bài viết mới nhất
        } catch (error) {
            console.error('Error fetching top categories with latest news:', error);
            throw error;
        }
    },

    async get12TopViewedNews() {
        try {
            const oneMonthAgo = new Date();
            const now = new Date(); 
            oneMonthAgo.setDate(oneMonthAgo.getDate() - 30); // Tính toán ngày 7 ngày trước

            const topNews = await db('News as n')
                .where('n.Id_Status', 'STS0001') // Lọc theo trạng thái
                .andWhere('n.Date', '<', now) 
                .andWhere('n.Date', '>=', oneMonthAgo) // Lọc theo ngày đăng trong 7 ngày gần nhất
                .orderBy('n.Views', 'desc')
                .select('n.*')
                .limit(12); // Lấy 10 bài viết có view cao nhất

            return topNews;
        } catch (error) {
            console.error('Error fetching top viewed news:', error);
            throw error;
        }
    },

    async getTopNewsFromTopCategory() {
        try {
            const now = new Date(); 
            // Bước 1: Lấy chuyên mục có tổng view cao nhất
            const topCategory = await db('Category as c')
                .join('SubCategory as sc', 'c.Id_Category', 'sc.Id_Category')
                .join('News as n', 'sc.Id_SubCategory', 'n.Id_SubCategory')
                .where('n.Id_Status', 'STS0001') // Lọc theo trạng thái
                .andWhere('n.Date', '<', now) 
                .select('c.Id_Category', 'c.Name as CategoryName')
                .groupBy('c.Id_Category', 'c.Name')
                .orderByRaw('SUM(n.Views) DESC')
                .first(); // Lấy chuyên mục có tổng view cao nhất

            //console.log('topCategory:', topCategory); // In ra topCategory
            if (!topCategory) {
                console.log('No top category found'); // Thêm log để kiểm tra
                return []; // Nếu không có chuyên mục nào, trả về mảng rỗng
            }
            //console.log('Top Category ID:', topCategory.Id_Category); // Kiểm tra ID chuyên mục

            // Bước 2: Lấy 4 bài viết nhiều view nhất từ chuyên mục đó
            const topNews = await db('News as n')
                .join('SubCategory as sc', 'n.Id_SubCategory', 'sc.Id_SubCategory') // Thêm JOIN với SubCategory
                .where('n.Id_Status', 'STS0001') // Lọc theo trạng thái
                .andWhere('n.Date', '<', now) 
                .andWhere('sc.Id_Category', topCategory.Id_Category) // Lọc theo chuyên mục
                .orderBy('n.Views', 'desc')
                .select('n.*')
                .limit(4); // Lấy 4 bài viết có view cao nhất

            //console.log('topNews:', topNews); // Thêm log để kiểm tra
            return topNews; // Trả về danh sách bài viết
        } catch (error) {
            console.error('Error fetching top news from top category:', error);
            throw error;
        }
    },
    async getTop10RecentNews() {
        try {
            const now = new Date(); 
            const topNews = await db('News as n')
                .join('SubCategory as sc', 'n.Id_SubCategory', 'sc.Id_SubCategory')
                .join('Category as c', 'sc.Id_Category', 'c.Id_Category') // Thêm JOIN với bảng Category
                .where('n.Id_Status', 'STS0001') 
                .andWhere('n.Date', '<', now) 
                .orderBy('n.Date', 'desc') // Sắp xếp theo ngày giảm dần
                .select('n.*', 'sc.Name as SubCategoryName', 'c.Name as CategoryName') // Lấy tên Category
                .limit(10); // Lấy 10 bài viết mới nhất

            return topNews;
        } catch (error) {
            console.error('Error fetching top 10 latest news:', error);
            throw error;
        }
    },
    async getRecentNewsFromCategory(categoryId) {
        try {
            const now = new Date(); 
            const latestNews = await db('News as n')
                .join('SubCategory as sc', 'n.Id_SubCategory', 'sc.Id_SubCategory') // Thêm JOIN với SubCategory
                .where('sc.Id_Category', categoryId) // Lọc theo category
                .andWhere('n.Date', '<', now) 
                .andWhere('n.Id_Status', 'STS0001') // Lọc theo trạng thái
                .orderBy('n.Date', 'desc') // Sắp xếp theo ngày giảm dần
                .select('n.*') // Lấy tất cả thông tin bài viết
                .limit(2); // Lấy 2 bài viết mới nhất
    
            return latestNews;
        } catch (error) {
            console.error('Error fetching latest news from category:', error);
            throw error;
        }
    },
    async get12RecentNewsFromCategory(categoryId) {
        try {
            const now = new Date(); 
            const latestNews = await db('News as n')
                .join('SubCategory as sc', 'n.Id_SubCategory', 'sc.Id_SubCategory')
                .where('sc.Id_Category', categoryId) // Lọc theo category
                .andWhere('n.Date', '<', now) 
                .andWhere('n.Id_Status', 'STS0001') // Lọc theo trạng thái
                .orderBy('n.Date', 'desc') // Sắp xếp theo ngày giảm dần
                .select('n.*') // Lấy tất cả thông tin bài viết
                .limit(12); // Lấy 12 bài viết mới nhất

            return latestNews;
        } catch (error) {
            console.error('Error fetching latest news from category:', error);
            throw error;
        }
    }
};

export default homeService;
