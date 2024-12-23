
import editorService from '../services/editor.service.js';
import express from 'express';
import moment from 'moment'
const router = express.Router();


// mặc định là 1 tháng
router.get('/home', async (req, res) => {
    const { Id_user } = req.query;
    let startDate = moment(moment().subtract(1, 'month').format('YYYY-MM-DD'));
    const endDate = moment(moment().format('YYYY-MM-DD'));
    let dates = [];
    let acceptCounts = [];
    let notAcceptCounts = [];
    let refuseCounts = [];
    let deleteCounts = [];
    const statusNewsArray = []
    while (startDate.isSameOrBefore(endDate)) {
        const statusNews = await editorService.countNewsStatusByUserId(Id_user, startDate.format('YYYY-MM-DD'));
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
    const  Id_user = req.query.Id_user;
    const filter  = req.query.filter;
    
   
    let startDate
    let endDate 
    if (filter === 'one_week') {
        startDate = moment(moment().subtract(1, 'week').format('YYYY-MM-DD'));
        endDate = moment(moment().format('YYYY-MM-DD'));
    }
    else if(filter === 'one_month'){
        startDate = moment(moment().subtract(1, 'month').format('YYYY-MM-DD'));
        endDate = moment(moment().format('YYYY-MM-DD'));
    }
    else if (filter==='custom'){
        startDate = moment(req.query.startDate,'YYYY-MM-DD')
        endDate = moment(req.query.endDate,'YYYY-MM-DD');
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
        const statusNews = await editorService.countNewsStatusByUserId(Id_user, startDate.format('YYYY-MM-DD'));
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
