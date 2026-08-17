// ============================================================
// Unique_ClotheShop / html / app.js
//
// BUG FIXED HERE: the old Unique_clotheshop app.js posted every NUI
// callback to 'http://sunset_clotheshop/...', but the resource that
// actually ships/runs this UI has always been named differently
// ('Unique_clotheshop', now 'Unique_ClotheShop'). FiveM's NUI POST
// routing is by resource name in the URL, so every single click in
// that shop silently 404'd -- getData/getColor/buyItem/etc never
// reached the Lua side at all. RESOURCE_NAME below MUST always match
// this resource's actual folder/fxmanifest name.
// ============================================================
const RESOURCE_NAME = 'Unique_ClotheShop';

function post(endpoint, data) {
    return $.post(`https://${RESOURCE_NAME}/${endpoint}`, JSON.stringify(data || {}));
}

let currentType = null;

function formatMoney(n) {
    n = Math.floor(Number(n) || 0);
    return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

// No real per-item clothing thumbnails ship with this resource (there
// never was an art catalog in the source data) -- render a clean
// generated placeholder (first letters of the type) instead of relying
// on image files that don't exist and would otherwise just show broken
// image icons.
function placeholderIcon(type) {
    const initials = (type || '?').slice(0, 2).toUpperCase();
    const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="65" height="65">
        <rect width="65" height="65" rx="10" fill="rgba(255,255,255,0.08)"/>
        <text x="50%" y="54%" font-family="sans-serif" font-size="20" fill="#fff"
              text-anchor="middle" dominant-baseline="middle">${initials}</text>
    </svg>`;
    return 'data:image/svg+xml;base64,' + btoa(svg);
}

function CloseShop() {
    $('.items').empty();
    $('.container').fadeOut(100, function () { $('body').hide(); });
    closeModal();
    post('focusOff');
}

function closeModal() {
    $('.modal').removeClass('visible');
}

document.addEventListener('DOMContentLoaded', function () {
    $('.container').hide();
    // body starts hidden (display:none in style.css) so the page isn't
    // visible before the shop opens -- but it must be shown again the
    // moment we actually want to draw the panel, or NUI focus activates
    // (cursor appears) while the whole page stays invisible.
    $('body').hide();
});

$(document).keyup(function (e) {
    if (e.key === 'Escape') CloseShop();
});

window.addEventListener('message', function (event) {
    const msg = event.data;

    if (msg.clear === true) {
        $('.items').empty();
        closeModal();
    }
    if (msg.display === true) {
        $('body').show();
        $('.container').show().hide().fadeIn(100);
        if (msg.shopLabel) $('.shopName').text(msg.shopLabel);
    }
    if (msg.display === false) {
        $('.container').fadeOut(100, function () { $('body').hide(); });
    }
    // one entry per accessible clothing type in this zone
    if (msg.type === 1) {
        $('.items').append(`
            <div class="item" onclick="loadType('${msg.name}', '${msg.label}')">
                <img class="img-item" src="${placeholderIcon(msg.name)}">
                <div class="label"><p class="itemString">${msg.label}</p></div>
            </div>
        `);
    }
});

function loadType(name, label) {
    currentType = name;
    $('.items').empty();
    post('getData', { name }).done(function (rows) {
        $('.items').append(`
            <div class="item" onclick="reload()">
                <img class="img-item" src="${placeholderIcon('<')}">
                <div class="label"><p class="itemString">Back</p></div>
            </div>
        `);
        (rows || []).forEach(function (row) {
            $('.items').append(`
                <div class="item" onclick="openPreview(${row.idx})">
                    <img class="img-item" src="${placeholderIcon(row.type)}">
                    <div class="label"><p class="itemString">${row.label}</p></div>
                </div>
            `);
        });
    });
}

function reload() {
    currentType = null;
    closeModal();
    post('reload');
}

function openPreview(idx) {
    post('getColor', { num: idx }).done(function (data) {
        const item = data && data['0'];
        if (!item) return;

        post('preview', { data: item });

        $('.modalimage').html(`<img src="${placeholderIcon(item.type)}" style="width:120px;height:120px;">`);
        $('.modal-info').html(`
            <p class="modal-label">${item.label}</p>
            <span class="modal-price">$${formatMoney(item.price)}</span>
        `);
        $('.btn-open').html(`<button class="btn-1" onclick="buyItem()"></button>`);
        $('.modal').addClass('visible');
    });
}

function buyItem() {
    post('buyItem');
}

$(document).on('click', function (event) {
    if (!$(event.target).closest('.modal, .items').length) {
        closeModal();
    }
});
