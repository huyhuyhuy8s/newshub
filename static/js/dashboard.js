// // Biểu đồ cột (Bar  Chart)
// const ctxBar = document.getElementById('categoryChart').getContext('2d');
// const categoryChart = new Chart(ctxBar, {
//     type:'bar',
//     data: {
//         labels: ['Thời sự', 'Kinh doanh', 'Khoa học', 'Thể thao', 'Giáo dục', 'Âm nhạc', 'Phim ảnh', 'Sức khỏe', 'Du lịch'],
//         datasets: [
//             {
//                 label: 'Quý 1',
//                 data: [80, 50, 70, 60, 90, 40, 50, 70, 80],
//                 backgroundColor: 'rgba(54, 162, 235, 0.5)'
//             },
//             {
//                 label: 'Quý 2',
//                 data: [60, 40, 80, 70, 85, 55, 65, 75, 90],
//                 backgroundColor: 'rgba(255, 206, 86, 0.5)'
//             },
//             {
//                 label: 'Quý 3',
//                 data: [70, 55, 75, 65, 95, 50, 60, 80, 85],
//                 backgroundColor: 'rgba(75, 192, 192, 0.5)'
//             },
//             {
//                 label: 'Quý 4',
//                 data: [70, 55, 75, 65, 95, 50, 60, 80, 85],
//                 backgroundColor: 'rgba(75, 192, 192, 0.5)'
//             },
//         ]
//     },
//     options: {
//         responsive: true,
//         plugins: {
//             legend: {
//                 position: 'top',
//             }
//         },
//         scales: {
//             y: {
//                 beginAtZero: true
//             }
//         }
//     }
// });

// // Biểu đồ tròn (Pie Chart)
// const ctxPie = document.getElementById('categoryPieChart').getContext('2d');
// const categoryPieChart = new Chart(ctxPie, {
//     type: 'pie',
//     data: {
//         labels: [
//             'Kinh doanh',
//             'Khoa học',
//             'Thể thao',
//             'Giáo dục',
//             'Đời sống',
//             'Thế giới',
//             'Bất động sản',
//             'Giải trí',
//             'Pháp luật',
//             'Sức khỏe'
//         ],
//         datasets: [{
//             data: [1500, 800, 900, 1800, 1300, 1400, 1700, 1600, 800, 1700],
//             backgroundColor: [
//                 '#8e44ad', // Kinh doanh
//                 '#e74c3c', // Khoa học
//                 '#3498db', // Thể thao
//                 '#f1c40f', // Giáo dục
//                 '#1abc9c', // Đời sống
//                 '#2ecc71', // Thế giới
//                 '#f39c12', // Bất động sản
//                 '#d35400', // Giải trí
//                 '#34495e', // Pháp luật
//                 '#9b59b6'  // Sức khỏe
//             ],
//             borderWidth: 1,
//             borderColor: '#fff',
//         }]
//     },
//     options: {
//         responsive: true,
//         plugins: {
//             legend: {
//                 position: 'right',
//                 labels: {
//                     font: {
//                         size: 14
//                     }
//                 }
//             },
//             tooltip: {
//                 callbacks: {
//                     label: function (tooltipItem) {
//                         return tooltipItem.label + ': ' + tooltipItem.raw;
//                     }
//                 }
//             }
//         }
//     }
// });
