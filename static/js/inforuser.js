document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('update-form');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('password-confirm');

    form.addEventListener('submit', async (event) => {
      
        const password = passwordInput.value;
        const confirmPassword = confirmPasswordInput.value;

        if (password !== confirmPassword) {
            event.preventDefault();
            alert('Mật khẩu và mật khẩu xác nhận không khớp!');
            return;
        }

   
    });
});

document.getElementById('back-btn').addEventListener('click', function() {
    window.location.href = '/'; // Chuyển hướng về trang chủ
});
