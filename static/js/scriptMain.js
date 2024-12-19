// set child2 height = child1 (include div1 and triple highlight)
// Adjust the heights
try {
    document.getElementsByClassName('child2')[0].style.height = `${document.getElementsByClassName('div1')[0].offsetHeight + document.getElementsByClassName('triple-highlight')[0].offsetHeight}px`;
}
catch { }
try {
    document.getElementById("article_top10").style.height = `${document.getElementsByClassName("grid-head")[0].offsetHeight + document.getElementById("article_list").offsetHeight}px`;
}
catch { }
try {
    document.getElementById("article_top10_2").style.height = `${document.getElementsByClassName("article-small")[0].offsetHeight}px`;
    document.getElementsByClassName("article-big")[0].style.height = `${document.getElementsByClassName("article-small")[0].offsetHeight}px`;
}
catch { }





// Sticky navbar
try {
    let navbar = document.getElementById("nav")
    let shouldStickPosition = navbar.offsetTop;

    // set sticky navbar
    function addOrRemoveStickyClass() {
        if (window.scrollY >= shouldStickPosition) {
            navbar.classList.add("sticky");
        } else {
            navbar.classList.remove("sticky");
        }
    }

    window.onscroll = function () {
        addOrRemoveStickyClass();
    }
}
catch { }


// Search click icon
try {
    let searchClickVar = false;
    // click and show on search icon
    function searchClick() {
        const input = document.createElement("input");
        input.type = "text";
        input.id = "searchInput";
        input.placeholder = "Tìm kiếm tin tức"; // Thêm placeholder nếu cần

        const li = document.createElement("li");
        li.appendChild(input);
        li.className = "left-input";

        const ul = document.getElementsByClassName("left")[0];

        if (searchClickVar) {
            // Nếu ô nhập đã tồn tại, xóa nó
            const existingInput = document.getElementById("searchInput");
            if (existingInput) {
                ul.removeChild(existingInput.parentElement); // Xóa li chứa input
            }
            searchClickVar = false;
            return;
        }

        // Thêm ô nhập vào danh sách
        ul.appendChild(li);
        searchClickVar = true;

        // Thêm sự kiện keydown cho ô nhập
        input.addEventListener('keydown', function (event) {
            if (event.key === 'Enter') {
                const query = input.value.trim(); // Lấy giá trị từ ô nhập
                if (query) {
                    window.location.href = `/search/search?q=${encodeURIComponent(query)}`; // Chuyển hướng đến trang tìm kiếm

                } else {
                    alert('Vui lòng nhập từ khóa tìm kiếm.'); // Thông báo nếu ô nhập rỗng
                }
            }
        });
        // Tùy chọn: Tự động focus vào ô nhập khi nó được tạo
        input.focus();
    }
} catch { }

// subnav
try {
    let nav_ul = document.getElementById('nav-ul');
    let subnav = document.getElementById('subnav');
    let targetnav;

    nav_ul.addEventListener('mouseover', (e) => {
        if (e.target.className !== '' && e.target.tagName !== 'a') {
            targetnav = document.getElementById(e.target.className);
            targetnav.hidden = false;
            targetnav.addEventListener('mouseover', (e) => {
                if (e.target.id !== '') {
                    targetnav.hidden = false;
                }
            })

            targetnav.addEventListener('mouseout', (e) => {
                if (targetnav !== null) {
                    targetnav.hidden = true;
                }
            })

            for (const key in targetnav.children) {
                var child_element = targetnav.children[key];
                child_element.addEventListener('mouseover', (e) => {
                    targetnav.hidden = false;
                });
                child_element.addEventListener('mouseout', (e) => {
                    targetnav.hidden = true;
                });
            };
        }
    })

    nav_ul.addEventListener('mouseout', (e) => {
        if (targetnav !== null) {
            targetnav.hidden = true;
        }
    })
}
catch { }


// Handle logout
try {
    function handleLogout(event) {
        event.preventDefault();
        // Xóa session hoặc localStorage nếu có
        // localStorage.removeItem('user');

        // Chuyển hướng về trang login
        window.location.href = '/account/logout';
    }
}
catch { }



document.addEventListener('DOMContentLoaded', function () {
    const navItems = document.querySelectorAll('#nav-ul li ');
    const subnavs = document.querySelectorAll('#subnav ul');

    navItems.forEach(item => {
        item.addEventListener('mouseenter', function () {
            // Ẩn tất cả submenu trước
            subnavs.forEach(subnav => subnav.hidden = true);

            // Hiển thị submenu tương ứng
            const categoryClass = this.className;
            const subnav = document.getElementById(categoryClass);
            if (subnav) {
                subnav.hidden = false;
            }
        });
    });

    // Ẩn submenu khi rời khỏi nav area
    document.getElementById('nav').addEventListener('mouseleave', function () {
        subnavs.forEach(subnav => subnav.hidden = true);
    });
});
