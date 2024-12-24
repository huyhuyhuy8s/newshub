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
        const categoryId = req.params.categoryId;
        const subCategoryId = req.params.subCategoryId;


        // Lấy thông tin subcategory
        const subcategory = await categoryService.findSubCategoryById(subCategoryId);
        if (!subcategory) {
            return res.status(404).send('Subcategory not found');
        }

        // Lấy các bài viết nhiều view nhất trong 7 ngày
        const allNews = await categoryService.getTopViewedNewsBySubCategory(subCategoryId, 7);

        // Pagnination
        const limit = 5;
        const page = parseInt(req.query.page) || 1
        const offset = (page - 1) * limit
        // Lấy các bài viết mới nhất của subcategory được giới hạn
        const recentNews = await categoryService.getRecentNewsBySubCategory(subCategoryId, limit, offset);

        // lấy số lượng nút nbaams của pagnination
        const nRows = await categoryService.countNewsbySubCategory(subCategoryId)
        const nPages = Math.ceil(nRows.total / limit)
        const page_items = []
        for (let i = 1; i <= nPages; i++) {
            const item = {
                value: i,
                isActive: i === page,
            }
            page_items.push(item)
        }
        //check thử có phải là trang đầu và trang cuối không?
        const isFirstPage = page === 1

        let previousPage = 1
        if (!isFirstPage) {
            previousPage = page - 1
        }
        const isLastPage = page === nPages

        let nextPage = page
        if (!isLastPage) {
            nextPage = page + 1
        }
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
            empty: allNews.length === 0,
            page_items: page_items,
            categoryId: categoryId,
            subCategoryId: subCategoryId,
            isFirstPage: isFirstPage,
            isLastPage: isLastPage,
            previousPage: previousPage,
            nextPage: nextPage
        });
    } catch (err) {
        console.error('Error in subcategory route:', err);
        res.status(500).send('Internal Server Error');
    }
});

export default router;