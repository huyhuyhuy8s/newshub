

document.getElementById('back-btn').addEventListener('click', function () {
    const id_user = this.getAttribute('data-id'); 
    window.location.href = `/admin/dashboard?id_user=${id_user}`; // Chuyển hướng về trang chủ
});


function logout() {
    window.location.href = '/account/logout'; // Chuyển hướng đến trang logout
};


