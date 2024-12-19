import express from 'express';
import adminService from '../services/admin.service.js';

const router = express.Router();

router.get("/dashboard", async (req, res) => {
    const getTotalNewsCount = await adminService.getTotalNewsCount()
    const getTotalUserCount = await adminService.getTotalUserCount()
    const getTotalStaffCount = await adminService.getTotalStaffCount()
    const getTotalAcceptNewsCount = await adminService.getTotalAcceptNewsCount()
    const getTotalNotAcceptNewCount = await adminService.getTotalNotAcceptNewCount()
    const getTotalNotRefuseNewCount = await adminService.getTotalNotRefuseNewCount()
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
        totalNotAcceptNewCount: getTotalNotAcceptNewCount,
        totalNotRefuseNewCount: getTotalNotRefuseNewCount,
        labelsBar: JSON.stringify(labelsBar),
        dataBar: JSON.stringify(dataBar),
        labelsPie: JSON.stringify(labelsPie),
        dataPie: JSON.stringify(dataPie),
        layout: 'admin'

    })
});

router.get("/usermanagement",  async(req,res)=>{
    const inforUser= await adminService.getUserInfor()
    
    res.render('vwAdmin/usermanagement',{
        inforUser:inforUser,
        layout:'admin'
    })
    
});



router.get("/admininforuser",async(req,res)=>{
    const {id_user}=req.query;
    const inforUser= await adminService.getUserInforById(id_user)
    console.log('inforUser:',inforUser)

    let newsCount = 0;
    if (inforUser.Id_Writer ) {
        newsCount = await adminService.getNewsCountByWriterId(inforUser.Id_Writer); 
    }
    console.log('inforUser id writer:',inforUser.Id_Writer)
    console.log('inforUser id editor:',inforUser.Id_Editor)
    console.log('inforUser id user:',inforUser.Id_User)
    console.log('newsCount:',newsCount)
    res.render('vwAdmin/admininforuser',{
        layout:'admin',
        inforUser:inforUser,
        newsCount: newsCount,
    })
});

export default router;