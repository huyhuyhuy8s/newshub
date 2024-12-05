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
}
catch { }

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


// OTP
try {
    const inputs = document.getElementsByClassName("information")[0];

    inputs.addEventListener("input", function (e) {
        const target = e.target;
        const val = target.value;

        if (isNaN(val)) {
            target.value = "";
            return;
        }

        if (val != "") {
            const next = target.nextElementSibling;
            if (next) {
                next.focus();
            }
        }
    });

    inputs.addEventListener("keyup", function (e) {
        const target = e.target;
        const key = e.key.toLowerCase();

        if (key == "backspace" || key == "delete") {
            target.value = "";
            const prev = target.previousElementSibling;
            if (prev) {
                prev.focus();
            }
            return;
        }
    });
}
catch { }