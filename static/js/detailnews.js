// console.log('Detail news script loaded');
function scrollNext(scroller, value, para = 1) {
    document.getElementById(scroller).scrollBy(para * document.getElementById(value).offsetWidth + 16, 0);
}



document.getElementById('submitComment').addEventListener('click', async () => {
    const commentInput = document.getElementById('commentInput');
    const comment = commentInput.value;
    const newsId = document.getElementById('newsId').value;
    const userId = document.getElementById('userId').value;
    const userName = document.getElementById('userName').value;
    


    if (comment.trim() === '') {
        alert('Vui lòng nhập bình luận!');
        return;
    }



    try {
        const response = await fetch('/news/comments', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ newsId, userId, comment }),
        });

        console.log('Response status:', response.status); // Log mã trạng thái
        const responseBody = await response.json(); // Chỉ đọc body một lần
        console.log('Response body:', responseBody); // Log nội dung phản hồi

        if (response.ok) {
            alert(responseBody.message);
            // Cập nhật danh sách bình luận mà không tải lại trang
            const commentsContainer = document.querySelector('.ours-comment');
            const newComment = document.createElement('div');
            newComment.classList.add('comment');
            newComment.innerHTML = `
                <div class="img-container">
                    <div class="image">
                        <img src="/imgs/detail/biden.jpg" alt="Avatar">
                    </div>
                    <h6>${userName}</h6>
                </div>
                <p>${comment}</p>
                <small>${"Ngày đăng: " + new Date().toLocaleDateString()}</small>
            `;
            // chỗ ngày đăng này không dùng formatDate được, nó sẽ bị lỗi
            commentsContainer.appendChild(newComment);
            commentInput.value = ''; // Xóa nội dung ô nhập
        } else {
            alert(responseBody.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi gửi bình luận! (js)');
    }
});
