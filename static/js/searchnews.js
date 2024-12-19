
const categorySelect = document.getElementById('category');
const subcategorySelect = document.getElementById('subcategory');

// Thêm sự kiện cho dropdown category
categorySelect.addEventListener('change', async function() {
    const selectedCategory = this.value;

    // Xóa tất cả các lựa chọn cũ trong subcategory
    subcategorySelect.innerHTML = '<option value="">Chọn chuyên mục cấp 2</option>';

    if (selectedCategory) {
        // Gửi yêu cầu đến server để lấy subcategories
        const response = await fetch(`/search/subcategories?categoryId=${selectedCategory}`);
        const subcategories = await response.json();

        // Thêm các subcategory vào dropdown
        subcategories.forEach(sub => {
            const option = document.createElement('option');
            option.value = sub.Id_SubCategory;
            option.textContent = sub.Name;
            subcategorySelect.appendChild(option);
        });
    }
});

async function fetchSearchResults() {
    const urlParams = new URLSearchParams(window.location.search);
    const query = urlParams.get('q');

    if (query) {
        const response = await fetch(`/search?q=${encodeURIComponent(query)}`);
        const results = await response.json();
        displayResults(results);
    }
}

function displayResults(results) {
    const parent = document.querySelector('.parent3');
    parent.innerHTML = ''; // Xóa kết quả trước đó

    results.forEach(result => {
        const post = document.createElement('a');
        post.className = 'post';
        post.href = `/news/${result.Id_News}`; // Liên kết đến trang chi tiết bài viết
        post.innerHTML = `
            <p>${new Date(result.Date).toLocaleString()}</p>
            <div class="content">
                <h4>${result.Title}</h4>
                <p>${result.Content.substring(0, 100)}...</p>
            </div>
            <img src="${result.Image}" alt="" class="image">
        `;
        parent.appendChild(post);
    });
}

// Gọi hàm fetchSearchResults khi trang được tải
document.addEventListener('DOMContentLoaded', fetchSearchResults);

// Thêm sự kiện cho ô nhập tìm kiếm
document.getElementById('searchInput').addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
        const query = this.value.trim(); // Lấy giá trị từ ô nhập
        if (query) {
            window.location.href = `/search/search?q=${encodeURIComponent(query)}`; // Chuyển hướng đến trang tìm kiếm
        } else {
            alert('Vui lòng nhập từ khóa tìm kiếm.'); // Thông báo nếu ô nhập rỗng
        }
    }
});

// Thêm sự kiện cho nút tìm kiếm
document.getElementById('searchButton').addEventListener('click', function() {
    const query = document.getElementById('searchInput').value.trim(); // Lấy giá trị từ ô nhập
    if (query) {
        window.location.href = `/search/search?q=${encodeURIComponent(query)}`; // Chuyển hướng đến trang tìm kiếm
    } else {
        alert('Vui lòng nhập từ khóa tìm kiếm.'); // Thông báo nếu ô nhập rỗng
    }
});

const tagSelect = document.getElementById('tag');

// Thêm sự kiện cho dropdown tag
tagSelect.addEventListener('change', function() {
    // Lặp qua tất cả các option trong dropdown
    Array.from(tagSelect.options).forEach(option => {
        if (option.selected) {
            option.classList.add('selected'); // Thêm lớp 'selected' cho tag đã chọn
        } else {
            option.classList.remove('selected'); // Xóa lớp 'selected' cho tag không được chọn
        }
    });
});










document.getElementById('searchButtonCategory&Subcategory&Tag&Date').addEventListener('click', function() {
    const selectedCategory = document.getElementById('category').value; // Lấy category đã chọn
    const selectedSubcategory = document.getElementById('subcategory').value; // Lấy subcategory đã chọn
    const selectedTag = document.getElementById('tag').value; // Lấy tag đã chọn
    const startDate = document.getElementById('startDate').value; // Lấy giá trị ngày bắt đầu
    const endDate = document.getElementById('endDate').value; // Lấy giá trị ngày kết thúc

    // Tạo query string cho các tham số tìm kiếm
    let queryParams = [];

    if (selectedCategory) {
        queryParams.push(`category=${encodeURIComponent(selectedCategory)}`);
        console.log('selectedCategory', selectedCategory);
    } else console.log('selectedCategory không có');
    if (selectedSubcategory) {
        queryParams.push(`subcategory=${encodeURIComponent(selectedSubcategory)}`);
        console.log('selectedSubcategory', selectedSubcategory);
    } else console.log('selectedSubcategory không có');
    if (selectedTag) {
        queryParams.push(`tags=${encodeURIComponent(selectedTag)}`);
        console.log('selectedTag', selectedTag);
    } else console.log('selectedTag không có');
    if (startDate) {
        queryParams.push(`startDate=${encodeURIComponent(startDate)}`);
        console.log('startDate', startDate);
    } else console.log('startDate không có');
    if (endDate) {
        queryParams.push(`endDate=${encodeURIComponent(endDate)}`);
        console.log('endDate', endDate);
    } else console.log('endDate không có');

    // Chuyển hướng đến trang tìm kiếm với các tham số đã tạo
    if (queryParams.length > 0) {
        window.location.href = `/search/searchnewsbyfilter?${queryParams.join('&')}`; // Chuyển hướng đến trang tìm kiếm
    } else {
        alert('Vui lòng chọn ít nhất một điều kiện tìm kiếm.'); // Thông báo nếu không có gì được nhập
    }
});