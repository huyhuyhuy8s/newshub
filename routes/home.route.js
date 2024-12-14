import express from 'express';
import homeService from '../services/home.service.js';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const topViewedNews = await homeService.getTopViewedNewsLastWeek(); // Lấy 4 bài viết nhiều view nhất trong 7 ngày gần đây
        const topCategoriesWithLatestNews = await homeService.getTopCategoriesWithLatestNews(); // Lấy 10 category nổi bật nhất với bài viết mới nhất
        const topViewedAllTime = await homeService.get12TopViewedNews(); // Lấy 10 bài viết có view cao nhất
        const topNewsFromTopCategory = await homeService.getTopNewsFromTopCategory(); // Lấy 4 bài viết nhiều view nhất từ chuyên mục có tổng view cao nhất
        const top10NewsRecent = await homeService.getTop10RecentNews(); // Lấy 10 bài viết nhiều views nhất
        const RecentTravelNews = await homeService.getRecentNewsFromCategory('CAT0012'); // Lấy 2 bài viết mới nhất từ category CAT0012
        const RecentHealthNews = await homeService.getRecentNewsFromCategory('CAT0011'); // Lấy 2 bài viết mới nhất từ category CAT0012

        const firstNewstopViewedNews = topViewedNews[0] || null;
        const News234stopViewedNews = topViewedNews.slice(1, 4);

        // Cắt 12 bài viết thành 3 phần
        const firstNewsget12TopViewedNews = topViewedAllTime.slice(0, 4); // Lấy 4 bài viết đầu tiên
        const secondNewsget12TopViewedNews = topViewedAllTime.slice(4, 8); // Lấy 4 bài viết tiếp theo
        const thirdNewsget12TopViewedNews = topViewedAllTime.slice(8, 12); // Lấy 4 bài viết cuối cùng

        const firstNewsgetTopNewsFromTopCategory = topNewsFromTopCategory[0] || null;
        const News234getTopNewsFromTopCategory = topNewsFromTopCategory.slice(1, 4);
        const topCategory = topCategoriesWithLatestNews[0] || null; // Lấy chuyên mục nổi bật nhất

        const firstNewsRecentTravelNews = RecentTravelNews[0] || null;
        const SecondNewsRecentTravelNews = RecentTravelNews[1] || null; 

        const firstNewsRecentHealthNews = RecentHealthNews[0] || null;
        const SecondNewsRecentHealthNews = RecentHealthNews[1] || null; 
    

        const top2Category = topCategoriesWithLatestNews[1] || null; // Lấy chuyên mục nổi bật nhì

        let latestNewsFromTop2Category = [];
        if (top2Category) {
            latestNewsFromTop2Category = await homeService.get12RecentNewsFromCategory(top2Category.Id_Category); // Lấy 12 bài viết mới nhất từ chuyên mục nổi bật nhì
        }

        const firstNewsFromTop2Category = latestNewsFromTop2Category.slice(0, 4); // Lấy 4 bài viết đầu tiên
        const secondNewsFromTop2Category = latestNewsFromTop2Category.slice(4, 8); // Lấy 4 bài viết tiếp theo
        const thirdNewsFromTop2Category = latestNewsFromTop2Category.slice(8, 12); // Lấy 4 bài viết cuối cùng



        const top3Category = topCategoriesWithLatestNews[2] || null; // Lấy chuyên mục nổi bật thứ 3

        let latestNewsFromTop3Category = [];
        if (top3Category) {
            latestNewsFromTop3Category = await homeService.get12RecentNewsFromCategory(top3Category.Id_Category); // Lấy 4 bài viết mới nhất từ chuyên mục nổi bật thứ 3
        }

        const firstNewsFromTop3Category = latestNewsFromTop3Category[0] || null; // Lấy 1 bài đầu tiên
        const secondNewsFromTop3Category = latestNewsFromTop3Category.slice(1, 4); // Lấy 3 bài tiếp theo

        res.render('home', {
            firstNewstopViewedNews,
            News234stopViewedNews,

            firstNewsget12TopViewedNews,
            secondNewsget12TopViewedNews,
            thirdNewsget12TopViewedNews,

            topCategories: topCategoriesWithLatestNews,
            topViewedAllTime,

            firstNewsgetTopNewsFromTopCategory,
            News234getTopNewsFromTopCategory,
            topCategory,

            top10NewsRecent,

            firstNewsRecentTravelNews,
            SecondNewsRecentTravelNews,

            firstNewsRecentHealthNews,
            SecondNewsRecentHealthNews,

            firstNewsFromTop2Category,
            secondNewsFromTop2Category,
            thirdNewsFromTop2Category,

            firstNewsFromTop3Category,
            secondNewsFromTop3Category,

            isHome: true,
        });
    } catch (error) {
        console.error('Error fetching data:', error);
        res.status(500).send('Internal Server Error');
    }
});

export default router;
