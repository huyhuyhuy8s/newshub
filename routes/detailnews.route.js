import express from 'express';
import newsService from '../services/detailnews.service.js';
const router = express.Router();

router.get('/:id', async function (req, res) {
    try {
        const newsId = req.params.id;

        // Tăng lượt xem cho bài viết
        await newsService.incrementViewCount(newsId);

        const news = await newsService.findById(newsId);
        const tags = await newsService.getNewsTags(newsId);
        const comments = await newsService.getCommentsByNewsId(newsId);
        const relatedNews = await newsService.getRelatedNewsByTag(newsId);

        // console.log('Related news in route:', relatedNews);
        // Lấy các bài viết nhiều lượt xem nhất trong cùng một danh mục
        const topViewedNews = await newsService.getTopViewedNewsInCategory(news.Id_SubCategory, newsId);

        // Lấy 3 bài viết nhiều lượt xem nhất trong 1 tuần qua
        const topViewedLastWeek = await newsService.getTopViewedNewsLastWeek();

        const userId = req.session.authUser ? req.session.authUser.Id_User : null;

        res.render('vwDetail/detailnews', {
            news: news,
            tags: tags,
            comments: comments,
            relatedNews: relatedNews,
            topViewedNews: topViewedNews,
            topViewedLastWeek: topViewedLastWeek,
            userId: userId
        });
    } catch (err) {
        console.error('Error in news detail route:', err);
        res.status(500).send('Internal Server Error');
    }
});

// Route để thêm bình luận
router.post('/comments', async (req, res) => {
    const { newsId, userId, comment, commentId } = req.body;
    console.log({ newsId, userId, comment, commentId });
    try {
        await newsService.addComment({ newsId, userId, comment, commentId });
        res.json({ message: 'Bình luận đã được gửi thành công!' });
    } catch (error) {
        console.error('Error saving comment:', error);
        res.status(500).json({ message: 'Có lỗi xảy ra khi gửi bình luận!' });
    }
});

export default router;
