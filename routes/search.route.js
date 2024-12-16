import express from 'express';
import searchService from '../services/search.service.js';

const router = express.Router();

router.get('/search', async (req, res) => {
    const query = req.query.q; // Lấy từ khóa tìm kiếm từ query string
    if (!query) {
        return res.status(400).send('Bad Request: Missing search query'); // Kiểm tra nếu không có từ khóa tìm kiếm
    }

    try {
        const results = await searchService.searchNews(query); // Gọi service để tìm kiếm
        res.render('vwSearchNews/searchnews', { 
            layout: 'main', // Sử dụng layout chính
            recentNews: results, 
            query // Truyền từ khóa tìm kiếm để hiển thị
        }); // Render kết quả tìm kiếm vào searchnews.hbs
    } catch (error) {
        console.error('Error searching news:', error);
        res.status(500).send('Internal Server Error'); // Xử lý lỗi
    }
});

export default router;