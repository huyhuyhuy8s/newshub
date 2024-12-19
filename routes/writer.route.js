import db from '../utils/db.js';
import writerService from '../services/writer.service.js';
import session from 'express-session';
import express from 'express';

const router = express.Router();

let id_user;

router.get('/home', async (req, res) => {
    id_user = req.query.id_user;
    res.render('vwWriter/overview', { layout: 'moderator' });
});

router.get('/list-post', async (req, res) => {
    res.render('vwWriter/list_post', { layout: 'moderator' });
});

router.get('/create-article', async (req, res) => {
    // let news = {
    //     Content: tinymce.activeEditor.getContent("article"),
    //     Title: document.getElementById('title').value,
    //     Premium: document.getElementById('premium').checked,
    //     Category: document.getElementById('category').value,
    //     Meta_title: document.getElementById('meta-title').value,
    //     Meta_description: document.getElementById('meta-description').value,
    // }
    const a = await writerService.findWriter(id_user)
    console.log(a);
    // link: document.getElementById('link').value,


    res.render('vwWriter/create_article', { layout: 'moderator' });
});

router.get('/preview', async (req, res) => {
    res.render('vwWriter/preview', { layout: 'moderator' });
});

export default router;