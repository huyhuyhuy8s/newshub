import express from 'express';
import searchService from '../services/searchnews.service.js';

const router = express.Router();

router.get('/search', async (req, res) => {
    const query = req.query.q; // Lấy từ khóa tìm kiếm từ query string
    if (!query) {
        return res.status(400).send('Bad Request: Missing search query'); // Kiểm tra nếu không có từ khóa tìm kiếm
    }

    try {
        const results = await searchService.searchNews(query); // Gọi service để tìm kiếm
        const categories = await searchService.getAllCategories(); // Lấy tất cả các category
        const subcategories = await searchService.getSubCategories(); // Lấy tất cả các subcategories
        const tags = await searchService.getAllTags(); // Lấy tất cả các tags

        // Lấy tag cho từng bài viết
        const recentnewsWithTags = await Promise.all(results.map(async (news) => {
            const newsTags = await searchService.getTagsByNewsId(news.Id_News);
            return {
                ...news,
                tags: newsTags // Thêm tags vào từng bài viết
            };
        }));

        res.render('vwSearchNews/searchnews', {
            layout: 'main',
            query, // Truyền từ khóa tìm kiếm để hiển thị
            recentnews: recentnewsWithTags, // Truyền kết quả tìm kiếm vào recentnews
            categories, // Truyền danh sách category
            subcategories, // Truyền danh sách subcategories
            tags // Truyền danh sách tags
        }); // Render kết quả tìm kiếm vào searchnews.hbs
    } catch (error) {
        console.error('Error searching news:', error);
        res.status(500).send('Internal Server Error'); // Xử lý lỗi
    }
});


router.get('/subcategories', async (req, res) => {
    const categoryId = req.query.categoryId; // Lấy Id_Category từ query string

    try {
        const subcategories = await searchService.getSubCategoriesByCategoryId(categoryId); // Gọi service để lấy subcategories
        res.json(subcategories); // Trả về danh sách subcategories dưới dạng JSON
    } catch (error) {
        console.error('Error fetching subcategories:', error);
        res.status(500).send('Internal Server Error'); // Xử lý lỗi
    }
});

router.get('/searchnewsbyfilter', async (req, res) => {
    const { category, subcategory, tags, startDate, endDate } = req.query; // Lấy các tham số từ query string

    try {
        const results = await searchService.searchNewsByFilters(category, subcategory, tags, startDate, endDate); // Gọi service để tìm kiếm
        const categories = await searchService.getAllCategories(); // Lấy tất cả các category
        const subcategories = await searchService.getSubCategories(); // Lấy tất cả các subcategories
        const allTags = await searchService.getAllTags(); // Lấy tất cả các tags

        // Lấy tag cho từng bài viết
        const recentnewsWithTags = await Promise.all(results.map(async (news) => {
            const newsTags = await searchService.getTagsByNewsId(news.Id_News);
            return {
                ...news,
                tags: newsTags // Thêm tags vào từng bài viết
            };
        }));

        res.render('vwSearchNews/searchnews', {
            layout: 'main',
            recentnews: recentnewsWithTags, // Truyền kết quả tìm kiếm vào recentnews
            categories, // Truyền danh sách category
            subcategories, // Truyền danh sách subcategories
            tags: allTags // Truyền danh sách tags
        }); // Render kết quả tìm kiếm vào searchnews.hbs
        // console.log('Category:', category);
        // console.log('Subcategory:', subcategory);
        // console.log('Tags:', tags);
        // console.log('Start Date:', startDate);
        // console.log('End Date:', endDate);
        // console.log('Results:', results);
    } catch (error) {
        console.error('Error searching news:', error);
        res.status(500).send('Internal Server Error'); // Xử lý lỗi
    }
});




export default router;
