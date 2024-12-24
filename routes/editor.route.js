import db from '../utils/db.js';
import editorService from '../services/editor.service.js';
import express from 'express';
import bcrypt from 'bcryptjs';
import moment from 'moment';

const router = express.Router();

let id_user;



// mặc định là 1 tháng
router.get('/home', async (req, res) => {
    const id = req.query.id_user;

    id_user = id;


    let startDate = moment(moment().subtract(1, 'month').format('YYYY-MM-DD'));
    const endDate = moment(moment().format('YYYY-MM-DD'));
    let dates = [];
    let acceptCounts = [];
    let notAcceptCounts = [];
    let refuseCounts = [];
    let deleteCounts = [];
    const statusNewsArray = []
    while (startDate.isSameOrBefore(endDate)) {
        const statusNews = await editorService.countNewsStatusByUserId(id_user, startDate.format('YYYY-MM-DD'));
        statusNewsArray.push(statusNews);
        dates.push(startDate.format('YYYY-MM-DD'));
        statusNews.statuses.forEach(status => {
            if (status.title_status === "Đồng ý") {
                acceptCounts.push(status.count)
            } if (status.title_status === "Chưa duyệt") {
                notAcceptCounts.push(status.count);
            }
            if (status.title_status === "Chưa đạt") {
                refuseCounts.push(status.count);
            }
            if (status.title_status === "Đã xoá") {
                deleteCounts.push(status.count);
            }
        });

        startDate.add(1, 'days'); // Tăng ngày lên 1
    }
    //console.log(notAcceptCounts)

    const totalAccept = acceptCounts.reduce((sum, current) => sum + current, 0);
    const totalNotAccept = notAcceptCounts.reduce((sum, current) => sum + current, 0);
    const totalRefuse = refuseCounts.reduce((sum, current) => sum + current, 0);
    const totalDelete = deleteCounts.reduce((sum, current) => sum + current, 0);
    res.render('vwEditor/overview', {
        layout: 'moderator',
        dates: JSON.stringify(dates),  // Truyền labels (Ngày 1, Ngày 2, ...)
        acceptCounts: JSON.stringify(acceptCounts),
        notAcceptCounts: JSON.stringify(notAcceptCounts),
        refuseCounts: JSON.stringify(refuseCounts),
        deleteCounts: JSON.stringify(deleteCounts),
        totalAccept: totalAccept,
        totalNotAccept: totalNotAccept,
        totalRefuse: totalRefuse,
        totalDelete: totalDelete,
        startDate: startDate,
        endDate: endDate
    });
});


router.get('/home/typefilter', async (req, res) => {
    //console.log("Hi")
    const id_user = req.query.id_user;
    const filter = req.query.filter;
    // if (id_user === undefined) id_user = req.query.id_user;



    let startDate
    let endDate
    if (filter === 'one_week') {
        startDate = moment(moment().subtract(1, 'week').format('YYYY-MM-DD'));
        endDate = moment(moment().format('YYYY-MM-DD'));
    }
    else if (filter === 'one_month') {
        startDate = moment(moment().subtract(1, 'month').format('YYYY-MM-DD'));
        endDate = moment(moment().format('YYYY-MM-DD'));
    }
    else if (filter === 'custom') {
        startDate = moment(req.query.startDate, 'YYYY-MM-DD')
        endDate = moment(req.query.endDate, 'YYYY-MM-DD');
    }
    // console.log(startDate)
    // endDate = moment(moment().format('YYYY-MM-DD'));
    let dates = [];
    let acceptCounts = [];
    let notAcceptCounts = [];
    let refuseCounts = [];
    let deleteCounts = [];
    const statusNewsArray = []
    while (startDate.isSameOrBefore(endDate)) {
        const statusNews = await editorService.countNewsStatusByUserId(id_user, startDate.format('YYYY-MM-DD'));
        statusNewsArray.push(statusNews);
        dates.push(startDate.format('YYYY-MM-DD'));
        statusNews.statuses.forEach(status => {
            if (status.title_status === "Đồng ý") {
                acceptCounts.push(status.count)
            } if (status.title_status === "Chưa duyệt") {
                notAcceptCounts.push(status.count);
            }
            if (status.title_status === "Chưa đạt") {
                refuseCounts.push(status.count);
            }
            if (status.title_status === "Đã xoá") {
                deleteCounts.push(status.count);
            }
        });

        startDate.add(1, 'days'); // Tăng ngày lên 1
    }


    const totalAccept = acceptCounts.reduce((sum, current) => sum + current, 0);
    const totalNotAccept = notAcceptCounts.reduce((sum, current) => sum + current, 0);
    const totalRefuse = refuseCounts.reduce((sum, current) => sum + current, 0);
    const totalDelete = deleteCounts.reduce((sum, current) => sum + current, 0);
    // console.log(acceptCounts)
    res.render('vwEditor/overview', {
        layout: 'moderator',
        dates: JSON.stringify(dates),  // Truyền labels (Ngày 1, Ngày 2, ...)
        acceptCounts: JSON.stringify(acceptCounts),
        notAcceptCounts: JSON.stringify(notAcceptCounts),
        refuseCounts: JSON.stringify(refuseCounts),
        deleteCounts: JSON.stringify(deleteCounts),
        totalAccept: totalAccept,
        totalNotAccept: totalNotAccept,
        totalRefuse: totalRefuse,
        totalDelete: totalDelete,
        startDate: startDate,
        endDate: endDate
    });

})



router.get('/inforeditor', async (req, res) => {
    const editor = await editorService.getUserById(id_user);

    if (editor.Birthday) {
        editor.Birthday = moment(editor.Birthday).format('YYYY-MM-DD'); // Đảm bảo định dạng đúng
    }


    res.render('vwEditor/inforeditor', { layout: 'moderator', editor });
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

// update prremium
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

router.post('/article/update-premium', async (req, res) => {
    const { id_news, updatedNews } = req.body; // Lấy id_news và newPremiumValue từ body


    try {

        await editorService.updateNewsPremium(id_news, updatedNews); // Gọi hàm cập nhật Premium

    } catch (error) {

        console.error('Lỗi khi cập nhật trạng thái Premium:', error);
        res.status(500).send('Có lỗi xảy ra');

    }
});






router.get('/list_article_reject', async (req, res) => {

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


// 24/12/2024
router.post('/article/update-date', async (req, res) => {
    const { id_news, date } = req.body; // Lấy id_news và date từ body

    try {
        await editorService.updateNewsDate(id_news, date); // Gọi hàm cập nhật ngày
        // res.status(200).send('Cập nhật ngày thành công');
        res.redirect(`/editor/article?id_news=${id_news}`);
    } catch (error) {
        console.error('Lỗi khi cập nhật ngày:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});




export default router;
