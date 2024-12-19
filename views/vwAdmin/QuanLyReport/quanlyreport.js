let reportId = 1; // Khởi tạo ID báo cáo
let currentPage = 1; // Trang hiện tại
let reportsPerPage = 5; // Số báo cáo hiển thị mỗi trang
let reports = []; // Danh sách lưu trữ các báo cáo

// Hàm thêm bài viết mới
function addNewReport(time, reporter, reportedPerson, reportedBlog, content) {
    const newId = reportId++; // Tăng ID mỗi khi có bài viết mới

    // Lưu báo cáo vào mảng reports
    const newReport = {
        id: newId,
        time: time,
        reporter: reporter,
        reportedPerson: reportedPerson,
        reportedBlog: reportedBlog,
        content: content,
        status: 'Chưa xử lý'
    };
    reports.push(newReport);

    renderReports(); // Cập nhật lại bảng báo cáo
}


// Hàm thay đổi trạng thái khi nhấn vào "Chưa xử lý"
// Hàm thay đổi trạng thái khi nhấn vào "Chưa xử lý"
function toggleStatus(span) {
    const row = span.closest('tr'); // Lấy hàng chứa báo cáo
    const statusCell = row.cells[6]; // Ô trạng thái
    const resolveButton = row.querySelector('.resolve'); // Nút "Đã xử lý"
    const reportId = row.cells[0].textContent.trim();
    const report = reports.find(r => r.id == reportId);

    // Hiển thị modal xác nhận
    const modal = document.getElementById('confirmation-modal');
    const confirmBtn = document.getElementById('confirm-btn');
    const cancelBtn = document.getElementById('cancel-btn');

    modal.style.display = 'block'; // Hiển thị modal

    // Xử lý khi nhấn "Xác nhận"
    confirmBtn.onclick = function() {
        if (span.classList.contains('pending')) {
            // Nếu trạng thái là "Chưa xử lý", chuyển sang "Đã xử lý"
            span.textContent = 'Đã xử lý';
            span.classList.remove('pending');
            span.classList.add('resolved');
            statusCell.classList.remove('pending');
            statusCell.classList.add('resolved');

            // Hiển thị nút "Đã xử lý"
            resolveButton.classList.remove('hidden');
        } else {
            // Nếu trạng thái là "Đã xử lý", chuyển lại về "Chưa xử lý"
            span.textContent = 'Chưa xử lý';
            span.classList.remove('resolved');
            span.classList.add('pending');
            statusCell.classList.remove('resolved');
            statusCell.classList.add('pending');

            // Ẩn nút "Đã xử lý"
            resolveButton.classList.add('hidden');
        }

        // Cập nhật lại trạng thái báo cáo
        if (report) {
            report.status = span.textContent; // Cập nhật trạng thái trong mảng báo cáo
        }

        modal.style.display = 'none'; // Ẩn modal sau khi xác nhận
        renderReports(); // Cập nhật lại bảng báo cáo
    };

    // Xử lý khi nhấn "Hủy"
    cancelBtn.onclick = function() {
        modal.style.display = 'none'; // Ẩn modal khi hủy
    };
}

// Hàm hiển thị báo cáo
function renderReports() {
    const tableBody = document.getElementById('report-table-body');
    tableBody.innerHTML = ''; // Xóa bảng hiện tại

    // Tính toán các báo cáo cần hiển thị
    const startIdx = (currentPage - 1) * reportsPerPage;
    const endIdx = Math.min(startIdx + reportsPerPage, reports.length);
    const reportsToDisplay = reports.slice(startIdx, endIdx);

    // Thêm báo cáo vào bảng
    reportsToDisplay.forEach(report => {
        const newRow = document.createElement('tr');
        newRow.innerHTML = `
            <td>${report.id}</td>
            <td>${report.time}</td>
            <td>${report.reporter}</td>
            <td>${report.reportedPerson}</td>
            <td>${report.reportedBlog}</td>
            <td>${report.content}</td>
            <td><span class="status ${report.status === 'Chưa xử lý' ? 'pending' : 'resolved'}" onclick="toggleStatus(this)">${report.status}</span></td>
            <td>
                <button class="action-button view" onclick="viewReport(${report.id})">Xem</button>
                <button class="action-button resolve ${report.status === 'Chưa xử lý' ? 'hidden' : ''}" onclick="resolveReport(${report.id})">Đã xử lý</button>
            </td>
        `;
        tableBody.appendChild(newRow);
    });
    

    // Cập nhật phân trang
    updatePagination();
}

// Hàm xem chi tiết báo cáo
function viewReport(reportId) {
    const report = reports.find(r => r.id === reportId);
    if (report) {
        alert(`Chi tiết báo cáo ID: ${report.id}\nThời gian: ${report.time}\nNgười báo cáo: ${report.reporter}\nNgười bị báo cáo: ${report.reportedPerson}\nBài viết: ${report.reportedBlog}\nNội dung: ${report.content}`);
    }
}

// Hàm xử lý báo cáo
function resolveReport(reportId) {
    const report = reports.find(r => r.id === reportId);
    if (report) {
        report.status = 'Đã xử lý';
        renderReports(); // Cập nhật lại bảng báo cáo
    }
}
// Cập nhật phân trang
function updatePagination() {
    const totalPages = Math.ceil(reports.length / reportsPerPage);
    const paginationButtons = document.querySelectorAll('.pagination button');

    // Lọc các nút trang
    paginationButtons.forEach(button => {
        if (button.classList.contains('prev')) {
            button.disabled = currentPage === 1;
        } else if (button.classList.contains('next')) {
            button.disabled = currentPage === totalPages;
        } else {
            button.style.display = 'inline-block';
            button.classList.remove('active');
            if (parseInt(button.textContent) === currentPage) {
                button.classList.add('active');
            }
        }
    });

    // Hiển thị các nút trang nếu cần
    const pageButtons = Array.from(paginationButtons).slice(1, -1); // Loại bỏ nút prev và next
    pageButtons.forEach(button => {
        const pageNum = parseInt(button.textContent);
        if (pageNum <= totalPages) {
            button.style.display = 'inline-block';
        } else {
            button.style.display = 'none';
        }
    });
}

// Xử lý khi nhấn nút "Next" hoặc "Prev"
document.querySelector('.pagination .prev').addEventListener('click', () => {
    if (currentPage > 1) {
        currentPage--;
        renderReports();
    }
});

document.querySelector('.pagination .next').addEventListener('click', () => {
    const totalPages = Math.ceil(reports.length / reportsPerPage);
    if (currentPage < totalPages) {
        currentPage++;
        renderReports();
    }
});

// Xử lý khi nhấn một trang cụ thể
document.querySelectorAll('.pagination button').forEach(button => {
    button.addEventListener('click', () => {
        if (!button.classList.contains('prev') && !button.classList.contains('next')) {
            currentPage = parseInt(button.textContent);
            renderReports();
        }
    });
});

// Thêm báo cáo mẫu (dùng cho thử nghiệm)
addNewReport('11/12/2024', 'Nguyễn Văn A', 'Nguyễn Văn C', 'Ronaldo cùng Messi lập hattrick', 'Bài viết chứa nội dung không phù hợp');
addNewReport('10/12/2024', 'Nguyễn Văn B', 'Trần Thị A', 'Bài viết về bóng đá', 'Bình luận chứa nhiều link rác');
addNewReport('09/12/2024', 'Nguyễn Văn C', 'Nguyễn Văn A', 'Bài viết về công nghệ', 'Bình luận chứa nhiều link rác');
addNewReport('08/12/2024', 'Nguyễn Văn D', 'Trần Thị B', 'Ronaldo cùng Messi lập hattrick', 'Bài viết chứa nội dung không phù hợp');
addNewReport('07/12/2024', 'Nguyễn Văn E', 'Nguyễn Thị C', 'Bài viết về thể thao', 'Bình luận chứa nhiều link rác');
addNewReport('06/12/2024', 'Nguyễn Văn F', 'Trần Thị D', 'Ronaldo cùng Messi lập hattrick', 'Bài viết chứa nội dung không phù hợp');

//Hàm logic cho filter