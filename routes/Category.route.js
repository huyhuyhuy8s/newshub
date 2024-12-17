import express from 'express';
import categoryService from '../services/Category.service.js';

const router = express.Router();

// Route để hiển thị danh sách categories
router.get('/', async function (req, res) {
    const list = await categoryService.findAll();  // Lấy danh sách category từ service
    res.render('vwCategory/list', {
        categories: list  // Truyền data cho view
    });
});

export default router;