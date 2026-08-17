var serverImage;
var lastType;
var loadedColor = {}
function CloseShop() {
    $(".items").empty();
    $(".container").fadeOut(100);
    $("body").fadeOut(100);
    closeModal()
    $.post('http://sunset_clotheshop/focusOff');
}
$(document).keyup(function(e) {
    if (e.key === "Escape") {
       CloseShop()
    }
    if (e.key == 4){
        $.post('http://sunset_clotheshop/key4');
    }
    if (e.key == 6){
        $.post('http://sunset_clotheshop/key6');
    }
});

function closeModal() {
    $(".modal").removeClass("visible");
}

window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.clear == true) {
        $(".items").empty();
    }
    if (item.display == true) {
        $(".container").show();
        $("body").show();
        $("body").fadeIn(100);
    }
    if (item.server) {
        serverImage = item.server
    }
    if (item.display == false) {
        $(".container").fadeOut(100);
        $("body").fadeOut(100);
    }
});

document.addEventListener('DOMContentLoaded', function () {
    $(".container").hide();
});

function buyItem(name) {
    $.post('http://sunset_clotheshop/buyItem', JSON.stringify({name: name}));
    //CloseShop()
}

function showClothe(k){
    data = loadedColor[k];
    $.post('http://sunset_clotheshop/preview', JSON.stringify({data}));
    $(".container").click(function(){
        $(".modal").addClass("visible");
        $(".modalimage").html(`<img src="` + serverImage + `/clothes/`+ data.type +`/`+ data.name +`.png" style="width:200px;height:200px;animation-name: slide-in; animation-duration: 0.5s;"><div class="itemName"><p class="modal-label">`+data.label+`</p><span class="modal-price">$`+formatMoney(data.price)+`</span></div><p class="modal-desc"></p>`);
        $(".btn-open").html(`<button class="btn-1" onclick="buyItem('`+ data.name + `')"></button>`);
    });

    $(".modal-close").click(function(){
        $(".modal").removeClass("visible");
    });

    $(document).click(function(event) {
        if (!$(event.target).closest(".modal,.items").length) {
            // $(".container").find(".modal").removeClass("visible");
        }
    });
}

function loadColor(num,_,name){
    closeModal()
	$(".items").empty();
    $.post('https://sunset_clotheshop/getColor', JSON.stringify({
        num:num
    }), function(data){
        loadedColor = data;
        $(".items").append(`
            <div class="item" onclick="loadClothe('`+ lastType +`')">
                <img class="img-item" src="` + serverImage + `/clothes/menu/reset.png">
                <div class="label">
                    <p class="itemString">Back</p>
                    </p>
                </div>
            </div>
        `);
        for (k in data) {
            $(".items").append(`
                <div class="item" onclick="showClothe(`+ k +`)">
                <img class="img-item" onerror="this.src = '` + serverImage + `/clothes/`+ data[k].type +`/`+ name +`.png'" src="` + serverImage + `/clothes/`+ data[k].type +`/`+ data[k].name +`.png">
                    <div class="label">
                        <p class="itemString">`+data[k].label+`</p>
                        </p>
                    </div>
                </div>
            `);
        }
    })
}

function reload(){
    $.post('https://sunset_clotheshop/reload');
}


function loadClothe(name){
	$(".items").empty();
    lastType = name;
    $.post('https://sunset_clotheshop/getData', JSON.stringify({
        name:name
    }), function(data){
        $(".items").append(`
            <div class="item" onclick="reload()">
                <img class="img-item" src="` + serverImage + `/clothes/menu/reset.png">
                <div class="label">
                    <p class="itemString">Back</p>
                    </p>
                </div>
            </div>
        `);
        for (k in data) {
            $(".items").append(`
                <div class="item" onclick="loadColor(`+data[k].num2+`,'` + data[k].name +`')">
                    <img class="img-item" src="` + serverImage + `/clothes/`+ data[k].type +`/`+ data[k].name +`.png">
                    <div class="label">
                        <p class="itemString">`+data[k].label+`</p>
                        </p>
                    </div>
                </div>
            `);
        }
    })
}

window.addEventListener('message', function (event) {
    var data = event.data;
    if (data.type == 1){
        $(".items").append(`
            <div class="item" onclick="loadClothe('`+data.name+`')">
                <img class="img-item" src="` + data.imglink + `">
                <div class="label">
                    <p class="itemString">`+data.label+`</p>
                    </p>
                </div>
            </div>
        `);
    }
});

 
{/* <p class="itemPrice"><span class="bg-price">$`+data.price+`</span> */}

function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;

    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
};