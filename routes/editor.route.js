import db from '../utils/db.js';
import editorService from '../services/editor.service.js';
import express from 'express';
import bcrypt from 'bcryptjs';
import moment from 'moment';

const router = express.Router();

let id_user;

router.get('/home', async (req, res) => {
    if (id_user === undefined) id_user = req.query.id_user;
    
    res.render('vwEditor/overview', { layout: 'moderator'});
});

// router.get('/list-writer', async (req, res) => {
//     res.render('vwEditor/list_writer', { layout: 'moderator' });
// });


// 21/12/2024




router.get('/inforeditor', async (req, res) => {
    const editor = await editorService.getUserById(id_user);

    if (editor.Birthday) {
        editor.Birthday = moment(editor.Birthday).format('YYYY-MM-DD'); // Đảm bảo định dạng đúng
    }

 
    res.render('vwEditor/inforeditor', { layout: 'moderator', editor});
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

        await editorService.updateUser(id_user, updatedUser); // Gọi hàm cập nhật với id_user
  

        // Chuyển hướng về trang thông tin người dùng
        res.redirect('/editor/inforeditor');
    } catch (error) {
        console.error('Error updating user info:', error);
        res.status(500).send('Có lỗi xảy ra, vui lòng thử lại! (route)'); // Trả về lỗi
        console.log('ko Cập nhật thành công');
    }
});




router.get('/list-article', async (req, res) => {

    
    const id_editor = await editorService.findEditor(id_user);
    
    const posts = await editorService.findAllPost(id_editor);
    
    res.render('vwEditor/list_article', { layout: 'moderator', posts });
});


router.post('/list-article/update-premium', async (req, res) => {
    const { id_news, newPremiumValue } = req.body; // Lấy id_news và newPremiumValue từ body
    try {
        await editorService.updateNewsPremium(id_news, newPremiumValue); // Gọi hàm cập nhật Premium
        res.status(200).send('Cập nhật trạng thái Premium thành công');
    } catch (error) {
        console.error('Lỗi khi cập nhật trạng thái Premium:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});




router.get('/article', async (req, res) => {
    const id_news = req.query.id_news; // Lấy Id_News từ query
  
    try {
        const news = await editorService.findNewsById(id_news); // Lấy thông tin bài viết
     
        if (!news) {
            return res.status(404).send('Bài viết không tồn tại');
        }
        res.render('vwEditor/article', { layout: 'moderator', news }); // Truyền thông tin bài viết vào view
    } catch (error) {
        console.error('Lỗi khi lấy thông tin bài viết:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});


router.post('/article/update-status', async (req, res) => {
    const { id_news, new_status } = req.body; // Lấy id_news và new_status từ body
    try {
        await editorService.updateNewsStatus(id_news, new_status); // Gọi hàm cập nhật trạng thái
        
        res.status(200).send('Cập nhật trạng thái thành công');
    } catch (error) {
        console.error('Lỗi khi cập nhật trạng thái:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});









router.get('/list-article_reject', async (req, res) => {

    try {
        const rejectedArticles = await editorService.getRejectedArticles(); // Gọi hàm để lấy dữ liệu
        res.render('vwEditor/list_article_reject', { layout: 'moderator', posts: rejectedArticles });
    } catch (error) {
        console.error('Lỗi khi lấy danh sách bài viết bị từ chối:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});

router.post('/article/reject-article', async (req, res) => {
    const { id_news, reason } = req.body; // Lấy thông tin từ body
    const date_feedback = new Date(); // Ngày hiện tại
    const id_editor = await editorService.findEditor(id_user);

    try {
        // Thêm lý do từ chối vào bảng Editor_Check_News
        await editorService.addRejectionReason(id_news, reason, id_editor, date_feedback);
        
        // Cập nhật Id_Status của bài viết
        await editorService.updateNewsStatus(id_news, 'STS0004'); // Cập nhật trạng thái thành "Từ chối"
        
        res.status(200).send('Lý do từ chối đã được lưu thành công.');
    } catch (error) {
        console.error('Lỗi khi lưu lý do từ chối:', error);
        res.status(500).send('Có lỗi xảy ra.');
    }
});


router.get('/list-writer', async (req, res) => {
    const id_editor = await editorService.findEditor(id_user);


    try {
        const writersWithStatusCount = await editorService.getWritersWithStatusCount(id_editor);
        res.render('vwEditor/list_writer', { layout: 'moderator', writers: writersWithStatusCount });
    } catch (error) {
        console.error('Lỗi khi lấy danh sách tác giả:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});





export default router;