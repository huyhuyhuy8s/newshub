import express from 'express';
import newsService from '../services/detailnews.service.js';
const router = express.Router();

router.get('/news', async function (req, res) {
    try {
        const newsId = req.query.id;

        const isSubscriber = req.session.isSubscriber;

        // Tăng lượt xem cho bài viết
        await newsService.incrementViewCount(newsId);

        // const news = await newsService.findById(newsId);
        // Tìm bài viết với thông tin về subscriber
        const news = await newsService.findById(newsId, isSubscriber);
        if (!news) {
            //return res.status(404).send('Bài viết nay không có quyền truy cập.');
            return res.render('vwDetail/defaultnews', {
                layout: 'main',
                message: 'Để xem được bài viết, vui lòng đăng ký thành viên.'
            });
        }

     


        const tags = await newsService.getNewsTags(newsId);
        const comments = await newsService.getCommentsByNewsId(newsId);
        const relatedNews = await newsService.getRelatedNewsByTag(newsId);

        // console.log('Related news in route:', relatedNews);
        // Lấy các bài viết nhiều lượt xem nhất trong cùng một danh mục
        const topViewedNews = await newsService.getTopViewedNewsInCategory(news.Id_SubCategory, newsId);

        // Lấy 3 bài viết nhiều lượt xem nhất trong 1 tuần qua
        const topViewedLastWeek = await newsService.getTopViewedNewsLastWeek();

        const userId = req.session.authUser ? req.session.authUser.Id_User : null;
        const userName = req.session.authUser ? req.session.authUser.Name : null;
        // console.log('userId:', userId);
        // console.log('news:', news);

        res.render('vwDetail/detailnews', {
            news: news,
            tags: tags,
            comments: comments,
            relatedNews: relatedNews,
            topViewedNews: topViewedNews,
            topViewedLastWeek: topViewedLastWeek,
            userId: userId,
            userName: userName,
            
            isSubscriber: isSubscriber
        });

      
    } catch (err) {
        console.error('Error in news detail route:', err);
        res.status(500).send('Internal Server Error');
    }
});

// Route để thêm bình luận
router.post('/comments', async (req, res) => {
    const { newsId, userId, comment } = req.body;
    try {
        await newsService.addComment({ newsId, userId, comment });
        res.json({ message: 'Bình luận đã được gửi thành công!' });
    } catch (error) {
        console.log('lỗi ở route');
        console.error('Error saving comment:', error);
        res.status(500).json({ message: 'Có lỗi xảy ra khi gửi bình luận! (route)' });
    }
});

export default router;
