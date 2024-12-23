const categorySelect = document.getElementById('category');
const subcategorySelect = document.getElementById('subcategory');

// Dữ liệu về các chuyên mục cấp 2
const subcategories = {
  'thoi-su': ['Chính trị', 'Dân sinh', 'Lao động - Việc làm', 'Giao thông'],
  'kinh-doanh': ['NetZero', 'Quốc tế', 'Doanh nghiệp', 'Chứng khoáng', 'E-Bank'],
  'khoa-hoc': ['Khoa học trong nước', 'Chỉ số PII', 'Tin tức', 'Phát minh', 'Ứng dụng', 'Thế giới tự nhiên'],
  'the-thao': ['Bóng đá', 'Lịch thi đấu', 'Marathon', 'Tennis', 'Các môn khác'],
  'giao-duc': ['Tin tức', 'Tuyển sinh', 'Chân dung', 'Du học', 'Học tiếng Anh', 'Giáo dục 4.0'],
  'doi-song': ['Nhịp sống', 'Tổ ấm', 'Bài học sống', 'Nấu ăn', 'Tiêu dùng'],
  'the-gioi': ['Bầu cử tổng thông Mỹ', 'Tư liệu', 'Phân tích', 'Quân sự'],
  'bat-dong-san': ['Chính sách', 'Thị trường', 'Dự án', 'Không gian sống'],
  'giai-tri': ['Giới sao (idol/star)', 'Sách', 'Phim', 'Nhạc', 'Thời trang', 'Làm đẹp', 'Mỹ thuật'],
  'phap-luat': ['Hồ sơ phá án', 'Tư vấn'],
  'suc-khoe': ['Tin tức', 'Sống khỏe', 'Vaccine', 'Bệnh Dịch'],
  'du-lich': ['Điểm đến', 'Ẩm thực', 'Dấu chân', 'Tư vấn', 'Cẩm nang']
};

// Hàm cập nhật danh sách chuyên mục cấp 2
categorySelect.addEventListener('change', function() {
  const selectedCategory = this.value;

  // Xóa tất cả các lựa chọn cũ trong subcategory
  subcategorySelect.innerHTML = '<option value="">Chọn chuyên mục cấp 2</option>';

  // Nếu có chuyên mục cấp 1 được chọn
  if (subcategories[selectedCategory]) {
    // Thêm các chuyên mục cấp 2 liên quan
    subcategories[selectedCategory].forEach(sub => {
      const option = document.createElement('option');
      option.value = sub.toLowerCase().replace(/\s/g, '-');
      option.textContent = sub;
      subcategorySelect.appendChild(option);
    });
  }
});
