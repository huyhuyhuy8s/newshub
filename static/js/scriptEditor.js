
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
    document.getElementById('rejectionContainer').style.display = 'flex'; // Hiển thị ô nhập lý do
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


async function togglePremium(id_news) {

    const currentPremiumStatus = document.getElementById('premium-toggle').innerText.includes('Free') ? false : true;
    const newPremiumValue = !currentPremiumStatus; // Đổi trạng thái

    const updatedNews = newPremiumValue ? 0 : 1;



    try {
        const response = await fetch('/editor/article/update-premium', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ id_news, updatedNews }),
        });
        if (response.ok) {

            location.reload();
        } else {
            alert('Có lỗi xảy ra khi cập nhật trạng thái Premium.');
            location.reload();
        }
    } catch (error) {
        location.reload();
    }
    location.reload();

};







function submitPostUpdate() {



    document.getElementById("save").value = tinymce.activeEditor.getContent("article");
};

function ChangeAccount() {
    var x = document.getElementById("ChangeAccount-Div");
    if (x.style.display === "none") {
        x.style.display = "grid";
    } else {
        x.style.display = "none";
    }
};

document.getElementById('save').hidden = true;

document.querySelector('input[type="file"]').addEventListener('change', e => {
    let file = e.target.files[0];
    let reader = new FileReader();
    reader.onload = function (evt) {
        let img = new Image();
        img.onload = (e) => {
            document.getElementById('custom_file_upload').style.backgroundImage = `url(${img.src})`;
            console.log(img.src);

            /* 
            To obtain a "storable" string representation of the image
            - write the image to a canvas and use `toDataURL` to get
            the base64 encoded source data....
            */
            let canvas = document.querySelector('canvas');
            canvas.width = img.width;
            canvas.height = img.height;

            let ctxt = canvas.getContext('2d');
            ctxt.drawImage(img, 0, 0);

            let imgstr = canvas.toDataURL(file.type);
            ctxt.clearRect(0, 0, ctxt.canvas.width, ctxt.canvas.height);

            console.log(imgstr)
        }
        img.src = evt.target.result;
    };
    reader.readAsDataURL(file);
});



