
function submitPost() {

  

    // Lấy giá trị từ các trường cần thiết
    const title = document.getElementById("title").value;
    const content = tinymce.activeEditor.getContent("article");
    const subCategory = document.getElementById("sub-category").value;
    const metaTitle = document.getElementById("meta-title").value;
    const metaDescription = document.getElementById("meta-description").value;
    const fileInput = document.getElementById("myFile").files.length; // Kiểm tra xem có file nào được chọn không

    // Kiểm tra xem tất cả các trường đã được điền chưa
    if (!title || !content || subCategory === "none" || !metaTitle || !metaDescription || fileInput === 0) {
        alert("Vui lòng điền đầy đủ thông tin!"); // Hiện thông báo lỗi
        return; // Ngăn không cho gửi form
    }
   

    document.getElementById("save").value = tinymce.activeEditor.getContent("article");
}


function submitPostUpdate() {



    document.getElementById("save").value = tinymce.activeEditor.getContent("article");
}

function ChangeAccount() {
    var x = document.getElementById("ChangeAccount-Div");
    if (x.style.display === "none") {
        x.style.display = "grid";
    } else {
        x.style.display = "none";
    }
}

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