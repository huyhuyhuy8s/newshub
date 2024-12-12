function scrollNext(scroller, value, para = 1) {
    document.getElementById(scroller).scrollBy(para * document.getElementById(value).offsetWidth + 16, 0);
}

document.getElementById('submitComment').addEventListener('click', async () => {
    const comment = document.getElementById('commentInput').value;
    const newsId = '{{news.Id_News}}'; // Lấy ID bài viết
    const userId = '{{userId}}'; // Sử dụng userId từ template

    if (comment.trim() === '') {
        alert('Vui lòng nhập bình luận!');
        return;
    }

    const commentId = `CMT${String(Date.now()).slice(-5)}`; // Tạo ID bình luận

    console.log({ newsId, userId, comment, commentId });

    try {
        const response = await fetch('/comments', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ newsId, userId, comment, commentId }),
        });

        if (response.ok) {
            const result = await response.json();
            alert(result.message);

            // Cập nhật danh sách bình luận mà không tải lại trang
            const commentsContainer = document.getElementById('commentsContainer'); // ID của phần chứa bình luận
            const newComment = document.createElement('div');
            newComment.innerHTML = `
                <div class="comment">
                    <div class="img-container">
                        <div class="image">
                            <img src="/imgs/detail/biden.jpg" alt="Avatar">
                        </div>
                        <h6>${userId}</h6>
                    </div>
                    <p>${comment}</p>
                    <small>${new Date().toLocaleString()}</small>
                </div>
            `;
            commentsContainer.appendChild(newComment);
            document.getElementById('commentInput').value = ''; // Xóa nội dung ô nhập
        } else {
            const error = await response.json();
            alert(error.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi gửi bình luận!');
    }
});
