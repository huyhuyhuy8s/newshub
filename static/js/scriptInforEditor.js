document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('update-form');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('password-confirm');

    form.addEventListener('submit', async (event) => {
        event.preventDefault(); // Ngăn không cho form được gửi theo cách mặc định

        const password = passwordInput.value;
        const confirmPassword = confirmPasswordInput.value;

        // Kiểm tra xem mật khẩu và mật khẩu xác nhận có khớp không
        if (password !== confirmPassword) {
            // event.preventDefault(); 
            alert('Mật khẩu và mật khẩu xác nhận không khớp!');
            return;
        }

        // Tạo đối tượng FormData để gửi dữ liệu
        const data = {
            id_user: form.querySelector('input[name="id_user"]').value,
            name: form.querySelector('input[name="name"]').value,
            birthday: form.querySelector('input[name="birthday"]').value,
            password: passwordInput.value,
        };

        try {
            const response = await fetch('/editor/inforeditor/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json', // Đặt header cho JSON
                },
                body: JSON.stringify(data), // Chuyển đổi đối tượng thành JSON
            });

            if (response.ok) {
                // Nếu cập nhật thành công, tải lại trang để hiển thị thông tin mới
                location.reload();
            } else {
                alert('Có lỗi xảy ra khi cập nhật thông tin respỏn.'); // Thông báo lỗi
            }
        } catch (error) {
            console.error('Lỗi khi gửi yêu cầu:', error);
            alert('Có lỗi xảy ra, vui lòng thử lại..');
        }
    });
});
document.getElementById('back-btn').addEventListener('click', function () {
    const id_user = this.getAttribute('data-id'); 
    window.location.href = `/editor/home?id_user=${id_user}`; // Chuyển hướng về trang chủ
});




function logout() {
    window.location.href = '/account/logout'; // Chuyển hướng đến trang logout
};



function updatePremium(id_news, isChecked) {
    const newPremiumValue = isChecked ? 1 : 0; // Nếu checked thì Premium = 1, ngược lại = 0
    fetch('/editor/list-article/update-premium', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ id_news, newPremiumValue }), // Gửi id_news và newPremiumValue
    })
    .then(response => {
        if (response.ok) {
            console.log('Cập nhật thành công');
        } else {
            console.error('Có lỗi xảy ra khi cập nhật trạng thái Premium');
        }
    })
    .catch(error => {
        console.error('Lỗi khi gửi yêu cầu:', error);
    });
}