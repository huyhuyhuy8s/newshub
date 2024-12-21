import writerService from '../services/writer.service.js';
import session from 'express-session';
import express from 'express';

const router = express.Router();

let id_user;

router.get('/home', async (req, res) => {
    if (id_user === undefined) id_user = req.query.id_user;
    res.render('vwWriter/overview', { layout: 'moderator' });
});

router.get('/list-post', async (req, res) => {
    const posts = await writerService.findAllPost(await writerService.findWriter(id_user));
    res.render('vwWriter/list_post', { layout: 'moderator', posts: posts });
});

router.get('/create-article', async (req, res) => {
    res.render('vwWriter/create_article', { layout: 'moderator' });
});

router.post('/create-article', async (req, res) => {
    const content = req.body.save;

    

    // let news = {
    //     Id_Writer: writerService.findWriter(id_user),
    //     Id_Status: "STS0001",
    //     Content: req.body.save,
    //     Image: '',
    //     Title: req.body.title,
    //     Premium: req.body.premium ? true : false,
    //     Id_SubCategory: req.body.sub_category,
    //     Meta_title: req.body.meta_title,
    //     Meta_description: req.body.meta_description,
    // }
    // writerService.addData(news);
})

router.get('/preview', async (req, res) => {
    res.render('vwWriter/preview', { layout: 'moderator' });
});

export default router;