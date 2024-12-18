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
    const viewsData = await adminService.getViewsByCategory();
    
   // Prepare data for the view
   const chartData = {
    labels: viewsData.map(item => item.CategoryName),
    datasets: [
      {
        label: 'Quý 1',
        data: viewsData.map(item => item.Quarter1Views),
        backgroundColor: 'rgba(54, 162, 235, 0.5)'
      },
      {
        label: 'Quý 2',
        data: viewsData.map(item => item.Quarter2Views),
        backgroundColor: 'rgba(255, 206, 86, 0.5)'
      },
      {
        label: 'Quý 3',
        data: viewsData.map(item => item.Quarter3Views),
        backgroundColor: 'rgba(75, 192, 192, 0.5)'
      },
      {
        label: 'Quý 4',
        data: viewsData.map(item => item.Quarter4Views),
        backgroundColor: 'rgba(8, 74, 22, 0.5)'
      }
    ]
  };


    res.render('vwAdmin/dashboard',{
       totalNewsCount:getTotalNewsCount,
       totalUserCount:getTotalUserCount,
       totalStaffCount:getTotalStaffCount,
       totalAcceptNewsCount:getTotalAcceptNewsCount,
       totalNotAcceptNewCount:getTotalNotAcceptNewCount,
       totalNotRefuseNewCount:getTotalNotRefuseNewCount,
       chartData: JSON.stringify(chartData),
       layout:'admin'
      
    })
})
export default router;