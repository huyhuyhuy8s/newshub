
async function fetchSubCategories(categoryId) {


    const response = await fetch(`/admin/subcategorymanagement/${categoryId}`);
    const subcategories = await response.json();
    const subcategoryTable = document.getElementById('article-table').getElementsByTagName('tbody')[0]; // Lấy tbody
    subcategoryTable.innerHTML = ''; // Xóa nội dung cũ

    subcategories.forEach((sub, index) => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${index + 1}</td> <!-- Số thứ tự -->
            <td>${sub.Name}</td>
        `;
        subcategoryTable.appendChild(row);
    });
}