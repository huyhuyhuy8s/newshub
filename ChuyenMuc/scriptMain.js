// set child2 height = child1 (include div1 and triple highlight)
document.getElementsByClassName('child2')[0].style.height = `${document.getElementsByClassName('div1')[0].offsetHeight + document.getElementsByClassName('triple-highlight')[0].offsetHeight}px`;

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

let searchClickVar = false;
// click and show on search icon
function searchClick() {
    if (searchClickVar) {
        const li = document.getElementsByClassName("left-input")[0];
        const ul = document.getElementsByClassName("left")[0];

        console.log(1);

        ul.removeChild(li);
        searchClickVar = !searchClickVar;
        return;
    }
    searchClickVar = !searchClickVar;
    console.log(2);
    const input = document.createElement("input");
    input.type = "text";

    const li = document.createElement("li");
    li.appendChild(input);
    li.className = "left-input";

    const ul = document.getElementsByClassName("left")[0];
    ul.appendChild(li);
}