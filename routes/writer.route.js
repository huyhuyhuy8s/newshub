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

// router.get('/home', async (req, res) => {

//     const id = req.query.id_user;

//     id_user = id;


//     res.render('vwWriter/overview', { layout: 'moderator', id_user });
// });


router.get('/home', async (req, res) => {


    const id = req.query.id_user;


    id_user = id;


    let startDate = moment(moment().subtract(1, 'month').format('YYYY-MM-DD'));
    const startDate1 = moment(moment().subtract(1, 'month').format('YYYY-MM-DD'))
    const endDate = moment(moment().format('YYYY-MM-DD'));
    let dates = [];
    let acceptCounts = [];
    let notAcceptCounts = [];
    let refuseCounts = [];
    let deleteCounts = [];
    const statusNewsArray = []
    while (startDate.isSameOrBefore(endDate)) {
        const statusNews = await writerService.countNewsStatusByUserId(id_user, startDate.format('YYYY-MM-DD'));
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
            if (status.title_status === "Từ chối") {
                deleteCounts.push(status.count);
            }
        });

        startDate.add(1, 'days'); // Tăng ngày lên 1
    }

    const totalAccept = acceptCounts.reduce((sum, current) => sum + current, 0);
    const totalNotAccept = notAcceptCounts.reduce((sum, current) => sum + current, 0);
    const totalRefuse = refuseCounts.reduce((sum, current) => sum + current, 0);
    const totalDelete = deleteCounts.reduce((sum, current) => sum + current, 0);
    res.render('vwWriter/overview', {
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
        startDate: startDate1,
        endDate: endDate,

        id_user
    });
});


router.get('/home/typefilter', async (req, res) => {
    const id_user = req.query.id_user;
    const filter = req.query.filter;


    let startDate
    let startDate1
    let endDate
    if (filter === 'one_week') {
        startDate = moment(moment().subtract(1, 'week').format('YYYY-MM-DD'));
        startDate1 = moment(moment().subtract(1, 'week').format('YYYY-MM-DD'));
        endDate = moment(moment().format('YYYY-MM-DD'));
    }
    else if (filter === 'one_month') {
        startDate = moment(moment().subtract(1, 'month').format('YYYY-MM-DD'));
        startDate1 = moment(moment().subtract(1, 'month').format('YYYY-MM-DD'));
        endDate = moment(moment().format('YYYY-MM-DD'));
    }
    else if (filter === 'custom') {
        startDate = moment(req.query.startDate, 'YYYY-MM-DD')
        startDate1 = moment(req.query.startDate, 'YYYY-MM-DD')
        endDate = moment(req.query.endDate, 'YYYY-MM-DD');
    }

    let dates = [];
    let acceptCounts = [];
    let notAcceptCounts = [];
    let refuseCounts = [];
    let deleteCounts = [];
    const statusNewsArray = []
    while (startDate.isSameOrBefore(endDate)) {
        const statusNews = await writerService.countNewsStatusByUserId(id_user, startDate.format('YYYY-MM-DD'));
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
            if (status.title_status === "Từ chối") {
                deleteCounts.push(status.count);
            }
        });

        startDate.add(1, 'days'); // Tăng ngày lên 1
    }



    const totalAccept = acceptCounts.reduce((sum, current) => sum + current, 0);
    const totalNotAccept = notAcceptCounts.reduce((sum, current) => sum + current, 0);
    const totalRefuse = refuseCounts.reduce((sum, current) => sum + current, 0);
    const totalDelete = deleteCounts.reduce((sum, current) => sum + current, 0);

    res.render('vwWriter/overview', {
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
        startDate: startDate1,
        endDate: endDate,

        id_user
    });
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




    try {
        const id_writer = await writerService.findWriter(id_user)
        const category = await writerService.getCategoryByWriterId(id_writer);
        const subCategories = await writerService.getSubCategoriesByWriterId(id_writer);  // Lấy danh sách sub-category

        res.render('vwWriter/create_article', { layout: 'moderator', id_user, category, subCategories });
    } catch (error) {
        console.error('Lỗi khi lấy chuyên mục:', error);
        res.status(500).send('Có lỗi xảy ra');
    }


});

router.post('/create-article', upload.single('filename'), async (req, res) => {




    let news = {
        Id_Writer: await writerService.findWriter(id_user),
        Id_Status: "STS0002",
        Content: req.body.save,
        // Image: req.file.filename,
        Image: req.file ? req.file.filename : null,

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


});

router.post('/update_article', upload.single('filename'), async (req, res) => {
    const { id_news, title, content, premium, sub_category, meta_title, meta_description } = req.body;



    try {
        const oldNews = await writerService.findNewsByIdFullAttribute(id_news);
        const updatedNews = {
            Title: title,
            Content: content,
            Premium: premium ? true : false,
            Id_SubCategory: sub_category,
            Meta_title: meta_title,
            Meta_description: meta_description,
            // Nếu có hình ảnh mới, bạn có thể thêm logic để xử lý
            Image: req.file ? req.file.filename : oldNews.Image,  // Nếu không có file, gán là null
        };


        await writerService.updateNews(id_news, updatedNews); // Gọi hàm cập nhật với id_news

        res.redirect(`/writer/list-post?id_user=${id_user}`); // Chuyển hướng về danh sách bài viết
    } catch (error) {
        console.error('Lỗi khi cập nhật bài viết:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});



router.get('/preview', async (req, res) => {
    res.render('vwWriter/preview', { layout: 'moderator', id_user });
});











router.get('/inforwriter', async (req, res) => {
    const writer = await writerService.getUserById(id_user);


    if (writer.Birthday) {
        writer.Birthday = moment(writer.Birthday).format('YYYY-MM-DD'); // Đảm bảo định dạng đúng
    }
    res.render('vwWriter/inforwriter', { layout: 'moderator', writer, id_user });
});


router.post('/inforwriter/update', async (req, res) => {
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
        res.redirect(`/writer/inforwriter?id_user=${id_user}`);
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


    const id_news = req.query.id_news;

    try {

        const news = await writerService.findNewsByIdFullAttribute(id_news);
        if (!news) {
            return res.status(404).send('Bài viết không tồn tại');
        }

        const id_writer = await writerService.findWriter(id_user);
        const category = await writerService.getCategoryByWriterId(id_writer);
        const subCategories = await writerService.getSubCategoriesByWriterId(id_writer);


        res.render('vwWriter/update_article', { layout: 'moderator', news, id_user, category, subCategories });
    } catch (error) {
        console.error('Lỗi khi lấy chuyên mục:', error);
        res.status(500).send('Có lỗi xảy ra');
    }

});


router.post('/update_article', upload.single('filename'), async (req, res) => {
    const { id_news, title, content, premium, sub_category, meta_title, meta_description } = req.body;

    try {
        const updatedNews = {
            Title: title,
            Content: content,
            Premium: premium ? true : false,
            Id_SubCategory: sub_category,
            Meta_title: meta_title,
            Meta_description: meta_description,
            // Nếu có hình ảnh mới, bạn có thể thêm logic để xử lý
        };

        await writerService.updateNews(id_news, updatedNews); // Gọi hàm cập nhật với id_news

        res.redirect(`/writer/list-post?id_user=${id_user}`); // Chuyển hướng về danh sách bài viết
    } catch (error) {
        console.error('Lỗi khi cập nhật bài viết:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});





export default router;