
async function updatePremium(id_news, isPremium) {
    const newPremiumValue = isPremium ? 1 : 0; // Nếu checked thì 1, ngược lại 0
    try {
        const response = await fetch('/editor/list-article/update-premium', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ id_news, newPremiumValue }),
        });

        if (response.ok) {
            alert('Cập nhật trạng thái Premium thành công');
        } else {
            alert('Có lỗi xảy ra khi cập nhật trạng thái Premium');
        }
    } catch (error) {
        console.error('Lỗi khi gửi yêu cầu:', error);
    }
}


async function updateStatus(id_news, new_status) {
    try {
        const response = await fetch('/editor/article/update-status', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ id_news, new_status }),
        });

        if (response.ok) {
            alert('Cập nhật trạng thái thành công');
            location.reload(); // Tải lại trang để cập nhật thông tin
        } else {
            alert('Có lỗi xảy ra khi cập nhật trạng thái');
        }
    } catch (error) {
        console.error('Lỗi khi gửi yêu cầu:', error);
    }
}

// viết lý do từ chôi
function showRejectionInput() {
    document.getElementById('rejectionContainer').style.display = 'block'; // Hiển thị ô nhập lý do
}

async function submitRejectionReason(id_news) {
    const reason = document.getElementById('rejectionReason').value;
    if (!reason) {
        alert('Vui lòng nhập lý do từ chối.');
        return;
    }

    try {
        // Gửi yêu cầu để tạo bản ghi trong Editor_Check_News và cập nhật Id_Status
        const response = await fetch('/editor/article/reject-article', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                id_news,
                reason
                // id_editor: '{{currentEditorId}}' // Thay thế bằng ID của editor hiện tại
            }),
        });

        if (response.ok) {
            alert('Lý do từ chối đã được gửi thành công.');
            location.reload(); // Tải lại trang để cập nhật
        } else {
            alert('Có lỗi xảy ra khi gửi lý do từ chối.');
        }
    } catch (error) {
        console.error('Lỗi khi gửi yêu cầu:', error);
    }
}


