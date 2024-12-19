import db from '../utils/db.js';
import express from 'express';

const router = express.Router();

router.get('/', async (req, res) => {
    res.render('vwWriter/overview', { layout: 'moderator' });
});

router.get('/list-post', async (req, res) => {
    res.render('vwWriter/list_post', { layout: 'moderator' });
});

router.get('/create-article', async (req, res) => {
    res.render('vwWriter/create_article', { layout: 'moderator' });
});

router.get('/preview', async (req, res) => {
    res.render('vwWriter/preview', { layout: 'moderator' });
});

export default router;