import express from 'express';
import categoryService from '../services/category.service.js';

const router = express.Router();

router.get('/:id', async function (req, res) {
    try {
        const categoryId = req.params.id;

        // Lấy thông tin category và subcategories
        const category = await categoryService.findById(categoryId);
        if (!category) {
            return res.status(404).send('Category not found');
        }

        // Lấy danh sách tin tức của category
        const allNews = await categoryService.getNewsByCategory(categoryId);
        // Lấy danh sách subcategories có nhiều views nhất
        const topSubCategories = await categoryService.getTopSubCategoriesByViews(categoryId);
        // Lấy tất cả bài viết của category sắp xếp theo thời gian
        const recentNews = await categoryService.getRecentNewsByCategory(categoryId);

        // Phân chia tin tức theo layout
        const firstNews = allNews[0] || null;
        const topNews = allNews.slice(1, 4);
        const otherNews = allNews.slice(4, 14);

        // // Log để debug (có thể bỏ)
        // console.log('Category loaded:', category.Name);
        // console.log('News count:', allNews.length);

        res.render('vwCategory/category', {
            layout: 'main',
            category,
            firstNews,
            topNews,
            otherNews,
            topSubCategories,
            recentNews,
            empty: allNews.length === 0
        });
    } catch (err) {
        console.error('Error in category route:', err);
        res.status(500).send('Internal Server Error');
    }
});



//sub_Category
router.get('/:categoryId/:subCategoryId', async function (req, res) {
    try {
        // const categoryId = req.params.categoryId;
        const subCategoryId = req.params.subCategoryId;

        // Lấy thông tin subcategory
        const subcategory = await categoryService.findSubCategoryById(subCategoryId);
        if (!subcategory) {
            return res.status(404).send('Subcategory not found');
        }

        // Lấy các bài viết nhiều view nhất trong 7 ngày
        const allNews = await categoryService.getTopViewedNewsBySubCategory(subCategoryId, 7);

        // Lấy các bài viết mới nhất của subcategory
        const recentNews = await categoryService.getRecentNewsBySubCategory(subCategoryId);

        // Phân chia tin tức cho parent1
        const firstNews = allNews[0] || null;
        const topNews = allNews.slice(1, 4);
        const otherNews = allNews.slice(4, 14);

        res.render('vwCategory/subcategory', {
            layout: 'main',
            subcategory,
            firstNews,
            topNews,
            otherNews,
            recentNews,
            empty: allNews.length === 0
        });
    } catch (err) {
        console.error('Error in subcategory route:', err);
        res.status(500).send('Internal Server Error');
    }
});

export default router;