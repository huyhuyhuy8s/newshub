let div1 = document.getElementsByClassName('div1')[0].offsetHeight;
let div234 = document.getElementsByClassName('div-234')[0].offsetHeight;
let sum = div234 + div1;
document.getElementsByClassName('child2')[0].style.height = `${sum}px`;

let navbar = document.getElementById("nav")
let shouldStickPosition = navbar.offsetTop;

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