import express from 'express';
import newsService from '../services/news.service.js';
const router = express.Router();

router.get('/:id', async function (req, res) {
    try {
        const newsId = req.params.id;
        const news = await newsService.findById(newsId);
        const tags = await newsService.getNewsTags(newsId);
        
        res.render('vwDetail/detail', {
            news: news,
            tags: tags
        });
    } catch (err) {
        console.error('Error in news detail route:', err);
        res.status(500).send('Internal Server Error');
    }
});

export default router;
