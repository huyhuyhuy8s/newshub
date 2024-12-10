//header
const items = document.querySelectorAll('.header-item');
items.forEach(item => {
    if (item.href === window.location.href) {
        item.style.backgroundColor = '#ffe6e6';
        item.style.fontWeight = 'bold';
    }
});

// Lấy các phần tử modal và các nút
const modal = document.getElementById('confirmation-modal');
const confirmBtn = document.getElementById('confirm-btn');
const cancelBtn = document.getElementById('cancel-btn');
let currentStatusElement = null; // Biến để lưu trạng thái hiện tại

// Hiển thị modal khi cần xác nhận thay đổi
document.querySelectorAll('.status').forEach(statusElement => {
    statusElement.addEventListener('click', function () {
        currentStatusElement = statusElement; // Lưu trạng thái hiện tại
        modal.classList.add('show'); // Hiển thị modal
    });
});

// Xử lý xác nhận thay đổi khi nhấn "Đồng ý"
confirmBtn.addEventListener('click', function () {
    if (currentStatusElement) {
        // Kiểm tra trạng thái hiện tại và thay đổi
        if (currentStatusElement.classList.contains('draft')) {
            currentStatusElement.classList.remove('draft');
            currentStatusElement.classList.add('published');
            currentStatusElement.textContent = 'Xuất bản';
        } else {
            currentStatusElement.classList.remove('published');
            currentStatusElement.classList.add('draft');
            currentStatusElement.textContent = 'Draft';
        }
    }
    modal.classList.remove('show'); // Đóng modal sau khi thay đổi
});

// Đóng modal khi nhấn "Hủy"
cancelBtn.addEventListener('click', function () {
    modal.classList.remove('show'); // Đóng modal 
});

