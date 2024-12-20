


document.addEventListener('DOMContentLoaded', function() {
    const updateButtons = document.querySelectorAll('.edit-button');

    updateButtons.forEach(button => {
        button.addEventListener('click', async function() {
            const newsId = this.getAttribute('data-id');
            const selectElement = document.querySelector(`.status-select[data-id="${newsId}"]`);
            const selectedStatus = selectElement.value;
    
            if (selectedStatus) {
                try {
                    const response = await fetch('/admin/newsmanagement/update-status', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({ id_news: newsId, status: selectedStatus }),
                    });
                    console.log('response', response.status);
                    if (response.ok) {
                        alert('Cập nhật trạng thái thành công!');
                        location.reload(); // Tải lại trang để cập nhật thông tin
                    } else {
                        alert('Có lỗi xảy ra khi cập nhật trạng thái.');
                    }
                } catch (error) {
                    console.error('Lỗi:', error);
                    alert('Có lỗi xảy ra khi cập nhật trạng thái.');
                }
            } else {
                alert('Vui lòng chọn trạng thái.');
            }
        });
    });
});