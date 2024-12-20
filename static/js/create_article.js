
function submitPost() {
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