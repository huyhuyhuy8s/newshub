import writerService from '../services/writer.service.js';
import session from 'express-session';
import express, { query } from 'express';
import bcrypt from 'bcryptjs';
import moment from 'moment';
import multer from 'multer';
import path from 'path';

var storage = multer.diskStorage(
    {
        destination: 'imgs/uploads/',
        filename: function (req, file, cb) {
            //req.body is empty...
            //How could I get the new_file_name property sent from client here?
            cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
        }
    }
);
let upload = multer({ storage: storage });
let id_user;

const router = express.Router();

router.get('/home', async (req, res) => {

    const id = req.query.id_user;

    id_user = id;


    res.render('vwWriter/overview', { layout: 'moderator', id_user });
});





router.get('/list-post', async (req, res) => {
    const posts = await writerService.findAllPost(await writerService.findWriter(id_user));



    for (let post of posts) {
        if (post.Id_Status === 'STS0004') { // Nếu trạng thái là "Từ chối"
            const reason = await writerService.getRejectionReason(post.Id_News);
            post.Reason = reason; // Gán lý do vào bài viết
        }
    }

    res.render('vwWriter/list_post', { layout: 'moderator', posts: posts, id_user });
});


router.get('/updatenews', async (req, res) => {
    const id_news = req.query.id_news; // Lấy Id_News từ query
    console.log('user id writer:', id_user);

    try {
        const news = await writerService.findNewsById(id_news); // Lấy thông tin bài viết

        if (!news) {
            return res.status(404).send('Bài viết không tồn tại');
        }
        res.render('vwWriter/updatenews', { layout: 'moderator', news, id_user }); // Truyền thông tin bài viết vào view
    } catch (error) {
        console.error('Lỗi khi lấy thông tin bài viết:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});




router.get('/create-article', async (req, res) => {

    console.log('user id writer cre:', id_user);


    try {
        const id_writer = await writerService.findWriter(id_user)
        const category = await writerService.getCategoryByWriterId(id_writer);
        const subCategories = await writerService.getSubCategoriesByWriterId(id_writer);  // Lấy danh sách sub-category

        res.render('vwWriter/create_article', { layout: 'moderator', id_user,category, subCategories });
    } catch (error) {
        console.error('Lỗi khi lấy chuyên mục:', error);
        res.status(500).send('Có lỗi xảy ra');
    }

    // res.render('vwWriter/create_article', { layout: 'moderator', id_user });
});

router.post('/create-article', upload.single('filename'), async (req, res) => {




    let news = {
        Id_Writer: await writerService.findWriter(id_user),
        Id_Status: "STS0002",
        Content: req.body.save,
        Image: req.file.filename,
        Title: req.body.title,
        Premium: req.body.premium ? true : false,
        // Id_Category: req.body.category,
        Id_SubCategory: req.body.sub_category,
        Meta_title: req.body.meta_title,
        Meta_description: req.body.meta_description,
    }
    writerService.addData(news);

    // res.render('vwWriter/list_post', { layout: 'moderator', id_user });

    res.redirect(`/writer/list-post?id_user=${id_user}`);


})

router.get('/preview', async (req, res) => {
    res.render('vwWriter/preview', { layout: 'moderator', id_user });
});











router.get('/inforeditor', async (req, res) => {
    const writer = await writerService.getUserById(id_user);


    if (writer.Birthday) {
        writer.Birthday = moment(writer.Birthday).format('YYYY-MM-DD'); // Đảm bảo định dạng đúng
    }


    res.render('vwWriter/inforwriter', { layout: 'moderator', writer, id_user });
});


router.post('/inforeditor/update', async (req, res) => {
    const { name, birthday, password, id_user } = req.body; // Lấy id_user từ body

    try {
        const updatedUser = {};

        // Cập nhật các trường nếu có giá trị
        if (name) updatedUser.Name = name;
        if (birthday) updatedUser.Birthday = moment(birthday).format('YYYY-MM-DD');

        // Chỉ mã hóa mật khẩu nếu có giá trị
        if (password) {
            const salt = bcrypt.genSaltSync(10);
            updatedUser.Password = bcrypt.hashSync(password, salt); // Mã hóa mật khẩu
        }

        // Kiểm tra xem có trường nào để cập nhật không
        if (Object.keys(updatedUser).length === 0) {
            return res.status(400).send('No fields to update');
        }

        await writerService.updateUser(id_user, updatedUser); // Gọi hàm cập nhật với id_user


        // Chuyển hướng về trang thông tin người dùng
        res.redirect('/writer/inforeditor');
    } catch (error) {
        console.error('Error updating user info:', error);
        res.status(500).send('Có lỗi xảy ra, vui lòng thử lại! (route)'); // Trả về lỗi
        console.log('ko Cập nhật thành công');
    }
});

router.get('/list_post_reject', async (req, res) => {


  


    try {
        const rejectedPost = await writerService.getRejectedPosts(await writerService.findWriter(id_user)); // Gọi hàm để lấy dữ liệu
      
        res.render('vwWriter/list_post_reject', { layout: 'moderator', posts: rejectedPost, id_user });
    } catch (error) {
        console.error('Lỗi khi lấy danh sách bài viết bị từ chối:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});




router.get('/update_article', async (req, res) => {

    console.log('user id writer cre:', id_user);
   
    const id_news = req.query.id_news; 
    console.log('id_news id writer id_news:', id_news);

    try {
        
        const news = await writerService.findNewsByIdFullAttribute(id_news); 
        if (!news) {
            return res.status(404).send('Bài viết không tồn tại');
        }
        console.log('neews:', news);
        const id_writer = await writerService.findWriter(id_user);
        const category = await writerService.getCategoryByWriterId(id_writer);
        const subCategories = await writerService.getSubCategoriesByWriterId(id_writer);
      

        res.render('vwWriter/update_article', { layout: 'moderator', news, id_user, category, subCategories });
    } catch (error) {
        console.error('Lỗi khi lấy chuyên mục:', error);
        res.status(500).send('Có lỗi xảy ra');
    }

});



export default router;