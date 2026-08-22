// ─────────────────────────────────────────────────────────
// Security app — shows recent login devices (from Unique_Login's
// login_audit table) and lets the player force-logout every device,
// including the current one, if they suspect their account is compromised.
// ─────────────────────────────────────────────────────────

var SecurityBusy = false;
var SecurityChangeBusy = false;

function timeAgoFa(dateStr) {
    if (!dateStr) return "نامشخص";
    var then = new Date(dateStr.replace(' ', 'T'));
    var now = new Date();
    var diffSec = Math.floor((now - then) / 1000);
    if (isNaN(diffSec)) return dateStr;
    if (diffSec < 60) return "چند لحظه پیش";
    if (diffSec < 3600) return Math.floor(diffSec / 60) + " دقیقه پیش";
    if (diffSec < 86400) return Math.floor(diffSec / 3600) + " ساعت پیش";
    return Math.floor(diffSec / 86400) + " روز پیش";
}

SetupSecurityDevices = function (data) {
    $("#security-devices").html("");

    if (!data || !data.devices) {
        $("#security-account-summary").text("خطا در دریافت اطلاعات.");
        return;
    }

    $("#security-account-summary").text(
        "اکانت: " + (data.username || "-") + " · " + data.devices.length + " دستگاه اخیر"
    );

    if (data.devices.length === 0) {
        $("#security-devices").html('<div class="security-empty">هنوز هیچ دستگاهی ثبت نشده.</div>');
        return;
    }

    $.each(data.devices, function (i, device) {
        var isCurrent = device.device_license === data.currentDeviceLicense;
        var badge = isCurrent ? '<span class="security-device-current-badge">همین دستگاه</span>' : '';

        var actionLabel = "ورود";
        if (device.action === "register") actionLabel = "ثبت‌نام";
        else if (device.action === "new_device") actionLabel = "دستگاه جدید";

        var el =
            '<div class="security-device' + (isCurrent ? ' security-device-current' : '') + '">' +
                '<div class="security-device-row">' +
                    '<i class="fas fa-mobile-alt security-device-icon"></i>' +
                    '<div class="security-device-info">' +
                        '<div class="security-device-label">' + badge + 'دستگاه #' + (i + 1) + '</div>' +
                        '<div class="security-device-meta">' + actionLabel + ' · ' + timeAgoFa(device.created_at) + '</div>' +
                    '</div>' +
                '</div>' +
            '</div>';

        $("#security-devices").append(el);
    });
};

$(document).on('click', '#security-logout-all', function (e) {
    e.preventDefault();
    if (SecurityBusy) return;
    $("#security-confirm-overlay").css({ display: "block" });
});

$(document).on('click', '#security-confirm-cancel', function (e) {
    e.preventDefault();
    $("#security-confirm-overlay").css({ display: "none" });
});

$(document).on('click', '#security-confirm-yes', function (e) {
    e.preventDefault();
    if (SecurityBusy) return;
    SecurityBusy = true;

    $("#security-confirm-overlay").css({ display: "none" });
    $("#security-logout-all").addClass("security-disabled").html('<i class="fas fa-spinner fa-spin"></i> در حال خروج...');

    $.post('http://Unique_Phone/LogoutAllDevices', JSON.stringify({}), function (result) {
        // The player gets dropped server-side right after this — nothing
        // else to do here, but reset the button state just in case the
        // drop is delayed for any reason.
        setTimeout(function () {
            SecurityBusy = false;
            $("#security-logout-all").removeClass("security-disabled")
                .html('<i class="fas fa-power-off"></i> خروج از همه‌ی دستگاه‌ها');
        }, 4000);
    });
});

// ── Change password ──────────────────────────────────────────
$(document).on('click', '#security-change-password-btn', function (e) {
    e.preventDefault();
    if (SecurityChangeBusy) return;

    var oldPassword = $("#security-old-password").val() || "";
    var newPassword = $("#security-new-password").val() || "";
    var confirmPassword = $("#security-confirm-password").val() || "";
    var msgEl = $("#security-change-msg");

    msgEl.removeClass("security-msg-error security-msg-ok").text("");

    if (!oldPassword || !newPassword || !confirmPassword) {
        msgEl.addClass("security-msg-error").text("همه‌ی فیلدها رو پر کن.");
        return;
    }
    if (newPassword.length < 6) {
        msgEl.addClass("security-msg-error").text("رمز جدید باید حداقل ۶ کاراکتر باشه.");
        return;
    }
    if (newPassword !== confirmPassword) {
        msgEl.addClass("security-msg-error").text("رمز جدید و تکرارش یکسان نیست.");
        return;
    }

    SecurityChangeBusy = true;
    $("#security-change-password-btn").addClass("security-disabled").text("در حال بررسی...");

    $.post('http://Unique_Phone/ChangePassword', JSON.stringify({
        oldPassword: oldPassword,
        newPassword: newPassword
    }), function (result) {
        SecurityChangeBusy = false;
        $("#security-change-password-btn").removeClass("security-disabled").text("تغییر رمز");

        if (result && result.success) {
            msgEl.addClass("security-msg-ok").text("رمز عبور با موفقیت تغییر کرد ✅");
            $("#security-old-password, #security-new-password, #security-confirm-password").val("");
        } else if (result && result.reason === "wrong_old_password") {
            msgEl.addClass("security-msg-error").text("رمز فعلی اشتباه است.");
        } else {
            msgEl.addClass("security-msg-error").text("خطایی پیش اومد، دوباره تلاش کن.");
        }
    });
});
