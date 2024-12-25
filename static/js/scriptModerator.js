// Sticky navbar
try {
    let navbar = document.getElementById("menu")
    let shouldStickPosition = navbar.offsetTop;
    let nav_bar = document.getElementsByTagName('nav')[0];
    let shouldStickPosition2 = nav_bar.offsetTop;

    // set sticky navbar
    function addOrRemoveStickyClass() {
        if (window.scrollY >= shouldStickPosition && window.scrollY >= shouldStickPosition2) {
            navbar.classList.add("sticky");
            nav_bar.classList.add("sticky2");
        } else {
            navbar.classList.remove("sticky");
            nav_bar.classList.remove("sticky2");
        }
    }

    window.onscroll = function () {
        addOrRemoveStickyClass();
    }
}
catch { }