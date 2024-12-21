import db from '../utils/db.js';
import editorService from '../services/editor.service.js';
import express from 'express';

const router = express.Router();

router.get('/home', async (req, res) => {
    const id_user = req.query;
    res.render('vwEditor/overview', { layout: 'moderator' });
});

router.get('/list-writer', async (req, res) => {
    res.render('vwEditor/list_writer', { layout: 'moderator' });
});

router.get('/list-article', async (req, res) => {
    res.render('vwEditor/list_article', { layout: 'moderator' });
});

router.get('/article', async (req, res) => {
    res.render('vwEditor/article', { layout: 'moderator' });
});

router.get('/list-article_reject', async (req, res) => {
    res.render('vwEditor/list_article_reject', { layout: 'moderator' });
});


export default router;