import express from 'express';
import moment from 'moment';
import adminService from '../services/admin.service.js';


const router = express.Router();

let id_user;

router.get("/dashboard", async (req, res) => {
    id_user  = req.query.id_user;

 

    const getTotalNewsCount = await adminService.getTotalNewsCount()
    const getTotalUserCount = await adminService.getTotalUserCount()
    const getTotalStaffCount = await adminService.getTotalStaffCount()
    const getTotalAcceptNewsCount = await adminService.getTotalAcceptNewsCount()
    const getTotalPendingNewsCount = await adminService.getTotalPendingNewsCount()
    const getTotalNotAcceptNewsCount = await adminService.getTotalNotAcceptNewsCount()
    const getTotalRefuseNewCount = await adminService.getTotalRefuseNewCount()
    // chart
    const viewsByCategoryAndQuater = await adminService.getViewsByCategoryAndQuater();
    const labelsBar = viewsByCategoryAndQuater.map(row => row.CategoryName);
    const dataBar = {
        Q1: viewsByCategoryAndQuater.map(row => row.Q1 || 0),
        Q2: viewsByCategoryAndQuater.map(row => row.Q2 || 0),
        Q3: viewsByCategoryAndQuater.map(row => row.Q3 || 0),
        Q4: viewsByCategoryAndQuater.map(row => row.Q4 || 0),
    };
    // pie Chart
    const viewsByCategory = await adminService.getViewsbyCategory();
    const labelsPie = viewsByCategory.map(row => row.CategoryName);
    const dataPie = viewsByCategory.map(row => row.TotalViews);
    res.render('vwAdmin/dashboard', {
        totalNewsCount: getTotalNewsCount,
        totalUserCount: getTotalUserCount,
        totalStaffCount: getTotalStaffCount,
        totalAcceptNewsCount: getTotalAcceptNewsCount,
        totalPendingNewsCount: getTotalPendingNewsCount,
        totalNotAcceptNewsCount: getTotalNotAcceptNewsCount,
        totalRefuseNewCount: getTotalRefuseNewCount,
        labelsBar: JSON.stringify(labelsBar),
        dataBar: JSON.stringify(dataBar),
        labelsPie: JSON.stringify(labelsPie),
        dataPie: JSON.stringify(dataPie),
        layout: 'moderator',

        id_user

    })
});

router.get("/usermanagement", async (req, res) => {
    const inforUser = await adminService.getUserInfor()


    res.render('vwAdmin/usermanagement', {
        inforUser: inforUser,
        layout: 'moderator',
        id_user
    })

});



router.get("/admininforuser", async (req, res) => {
    const { id_user } = req.query;
    const inforUser = await adminService.getUserInforById(id_user)
    const subscriberInfo = await adminService.getSubscriberInfoByUserId(id_user); // Lấy thông tin Subscriber





    // Lấy id_Category của Editor
    const categoryId = await adminService.getCategoryIdByEditorId(inforUser.Id_Editor);

    // Lấy số lượng bài viết cho Editor dựa trên id_Category
    const newsCounts = await adminService.getNewsCountsForEditor(categoryId);

    const categories = await adminService.getCategories();


    let newsCountApproved = 0;
    let newsCountPending = 0;
    let newsCountRejected = 0;
    let newsCountNotAccepted = 0;

    if (inforUser.Id_Writer) {
        newsCountApproved = await adminService.getNewsCountByWriterIdAndStatus(inforUser.Id_Writer, 'STS0001'); // Đã duyệt
        newsCountPending = await adminService.getNewsCountByWriterIdAndStatus(inforUser.Id_Writer, 'STS0002'); // Chưa duyệt
        newsCountNotAccepted = await adminService.getNewsCountByWriterIdAndStatus(inforUser.Id_Writer, 'STS0003'); // Chưa đạt
        newsCountRejected = await adminService.getNewsCountByWriterIdAndStatus(inforUser.Id_Writer, 'STS0004'); // Bị từ chối

    }


    res.render('vwAdmin/admininforuser', {
        layout: 'moderator',
        inforUser: inforUser,
        newsCountApproved: newsCountApproved,
        newsCountPending: newsCountPending,
        newsCountNotAccepted: newsCountNotAccepted,
        newsCountRejected: newsCountRejected,
        subscriberInfo: subscriberInfo,

        newsCounts: newsCounts,

        categories: categories,
        id_user
    })
});

router.post("/admininforuser/update", async (req, res) => {
    const { id_user, name, birthday, pen_name } = req.body; // Lấy thông tin từ body

    try {
        await adminService.updateUserInfo(id_user, name, birthday, pen_name); // Gọi hàm cập nhật thông tin
        res.redirect(`/admin/admininforuser?id_user=${id_user}`); // Chuyển hướng về trang thông tin người dùng
    } catch (error) {
        console.error("Lỗi khi cập nhật thông tin người dùng:", error);
        res.status(500).send("Có lỗi xảy ra khi cập nhật thông tin người dùng.");
    }
});



router.post("/subcriber/update", async (req, res) => {
    const { id_user } = req.body; // Lấy Id_User từ body

    try {
        // Lấy thông tin Subscriber hiện tại
        const subscriberInfo = await adminService.getSubscriberInfoByUserId(id_user);

        if (subscriberInfo) {
            const currentDate = new Date();
            const expirationDate = new Date(subscriberInfo.Date_expired);

            if (currentDate > expirationDate) {
                // Nếu ngày hiện tại lớn hơn ngày hết hạn, xóa Subscriber
                await adminService.deleteSubscriber(subscriberInfo.Id_Subcriber);
                // console.log('Subscriber đã được xóa do ngày hết hạn đã qua.');
                res.redirect(`/admin/admininforuser?id_user=${id_user}`); // Chuyển hướng về trang thông tin của Subscriber
            } else {
                // Cộng thêm 7 ngày vào ngày hết hạn
                const newExpirationDate = new Date(expirationDate);
                newExpirationDate.setDate(newExpirationDate.getDate() + 7); // Cộng thêm 7 ngày

                // Cập nhật ngày hết hạn trong database
                await adminService.updateSubscriberRequest(id_user, 0);
                await adminService.updateSubscriberExpirationDate(subscriberInfo.Id_Subcriber, newExpirationDate);
                // console.log('Cập nhật ngày hết hạn thành công:', newExpirationDate);
                res.redirect(`/admin/admininforuser?id_user=${id_user}`); // Chuyển hướng về trang thông tin của Subscriber
            }
        } else {
            res.status(404).send("Subscriber không tìm thấy.");
        }
    } catch (error) {
        console.error("Lỗi khi cập nhật ngày hết hạn:", error);
        res.status(500).send("Có lỗi xảy ra khi cập nhật ngày hết hạn.");
    }
});


router.post("/subcriber/create", async (req, res) => {
    const { id_user } = req.body; // Lấy Id_User từ body

    console.log('id user sub:', id_user);

    try {
        // Tạo một Subscriber mới
        const newSubscriberId = await adminService.addUsertoSubcriber(id_user);
        console.log('newSubscriberId:', newSubscriberId);
        //console.log('Tạo Subscriber mới thành công với ID:', newSubscriberId);
        res.redirect(`/admin/admininforuser?id_user=${id_user}`); // Chuyển hướng về trang thông tin của Subscriber mới
    } catch (error) {
        console.error("Lỗi khi tạo Subscriber:", error);
        res.status(500).send("Có lỗi xảy ra khi tạo Subscriber.");
    }
});

// 24/12/2024
router.post('/editor/create', async (req, res) => {
    const { id_user, id_category } = req.body;


    try {
        await adminService.createEditor(id_user, id_category); // Gọi hàm tạo editor
        res.redirect(`/admin/admininforuser?id_user=${id_user}`); // Chuyển hướng đến trang thành công
    } catch (error) {
        console.error('Lỗi khi tạo biên tập viên:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});

router.post('/writer/create', async (req, res) => {
    const { id_user, id_category, penname } = req.body;


    try {
        await adminService.createWriter(id_user, id_category, penname); // Gọi hàm tạo editor
        res.redirect(`/admin/admininforuser?id_user=${id_user}`); // Chuyển hướng đến trang thành công
    } catch (error) {
        console.error('Lỗi khi tạo nhà báo:', error);
        res.status(500).send('Có lỗi xảy ra');
    }
});












router.post("/writer/delete", async (req, res) => {
    const { id_user } = req.body; // Lấy Id_User từ body

    try {
        // Xóa writer
        await adminService.deleteWriter(id_user);
        res.redirect(`/admin/usermanagement`); // Chuyển hướng về trang quản lý người dùng
    } catch (error) {
        console.error("Lỗi khi xóa writer:", error);
        res.status(500).send("Có lỗi xảy ra khi xóa writer.");
    }
});

router.post("/editor/delete", async (req, res) => {
    const { id_user } = req.body; // Lấy Id_User từ body

    try {
        // Xóa editor
        await adminService.deleteEditor(id_user);
        res.redirect(`/admin/usermanagement`); // Chuyển hướng về trang quản lý người dùng
    } catch (error) {
        console.error("Lỗi khi xóa editor:", error);
        res.status(500).send("Có lỗi xảy ra khi xóa editor.");
    }
});

router.get("/newsmanagement", async (req, res) => {
    try {
        const newsDetails = await adminService.getNewsDetails(); // Lấy thông tin bài viết

        res.render('vwAdmin/newsmanagement', {
            layout: 'moderator',
            newsDetails: newsDetails,
            id_user
        });
    } catch (error) {
        console.error("Lỗi khi lấy thông tin bài viết:", error);
        res.status(500).send("Có lỗi xảy ra khi lấy thông tin bài viết.");
    }
});

router.post("/newsmanagement/update-status", async (req, res) => {
    const { id_news, status } = req.body;


    try {
        await adminService.updateNewsStatus(id_news, status); // Gọi hàm cập nhật trạng thái
        return res.redirect('/admin/newsmanagement'); // Chỉ cần chuyển hướng
    } catch (error) {
        console.error("Lỗi khi cập nhật trạng thái:", error);
        return res.status(500).send("Có lỗi xảy ra khi cập nhật trạng thái."); // Gửi phản hồi lỗi
    }
});


router.get('/tagsmanagement', async (req, res) => {
   
    try {

        const tags = await adminService.getTags(); // Lấy danh sách tag
        res.render('vwAdmin/tagsmanagement', {
            layout: 'moderator',
            tags: tags,
            id_user // Truyền danh sách tag vào view
        });
       
    } catch (error) {
        console.error("Lỗi khi lấy danh sách tag:", error);
        res.status(500).send("Có lỗi xảy ra khi lấy danh sách tag.");
    }
});

router.post('/tagsmanagement/add', async (req, res) => {
    const { tag_name } = req.body; // Lấy tên tag từ body


    try {
        await adminService.addTag(tag_name); // Gọi hàm thêm tag
        res.redirect('/admin/tagsmanagement'); // Chuyển hướng về trang quản lý tag
    } catch (error) {
        console.error('Lỗi khi thêm tag:', error);
        res.status(500).send('Có lỗi xảy ra khi thêm tag.');
    }
});

router.post('/tagsmanagement/delete', async (req, res) => {
    const { id_tag } = req.body; // Lấy Id_Tag từ body

    try {
        await adminService.deleteTag(id_tag); // Gọi hàm xóa tag
        res.redirect('/admin/tagsmanagement'); // Chuyển hướng về trang quản lý tag
    } catch (error) {
        console.error('Lỗi khi xóa tag:', error);
        res.status(500).send('Có lỗi xảy ra khi xóa tag.');
    }
});




router.get('/subcategorymanagement', async (req, res) => {
    // const { id_category } = req.params;
    const categories = await adminService.getCategories();


    try {

        res.render('vwAdmin/subcategorymanagement', {
            layout: 'moderator',
            categories: categories,
            id_user

        });
    } catch (error) {
        console.error("Lỗi khi lấy danh sách chuyên mục:", error);
        res.status(500).send("Có lỗi xảy ra khi lấy danh sách chuyên mục.");
    }
});

router.get('/subcategorymanagement/:id_category', async (req, res) => {
    const { id_category } = req.params;

    try {
        const subcategories = await adminService.getSubCategoriesByCategoryId(id_category);

        res.json(subcategories); // Trả về danh sách subcategories dưới dạng JSON
    } catch (error) {
        console.error("Lỗi khi lấy subcategories:", error);
        res.status(500).send("Có lỗi xảy ra khi lấy subcategories.");
    }
});


router.post('/subcategorymanagement/add', async (req, res) => {
    const { id_category, name } = req.body; // Lấy thông tin từ body


    try {
        const newSubCategory = await adminService.addSubCategory(id_category, name); // Gọi hàm thêm subcategory
        res.redirect('/admin/subcategorymanagement'); // Chuyển hướng về trang quản lý subcategory
    } catch (error) {
        console.error("Lỗi khi thêm subcategory:", error);
        res.status(500).send("Có lỗi xảy ra khi thêm subcategory.");
    }
});

router.get('/inforadmin', async (req, res) => {
    const admin = await adminService.getUserById(id_user);
 

    if (admin.Birthday) {
        admin.Birthday = moment(admin.Birthday).format('YYYY-MM-DD'); // Đảm bảo định dạng đúng
    }


    res.render('vwAdmin/inforadmin', { layout: 'moderator', admin, id_user });
});


export default router;
