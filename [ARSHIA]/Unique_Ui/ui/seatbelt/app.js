window.addEventListener('message', function (e) {
	// ✅ فیکس شد: چون همه‌ی ماژول‌ها (hud/skill/seatbelt/streetlabel) تو یه
	// صفحه‌ی مشترک لود میشن و همه پیام میگیرن، بدون این چک روی id، این اسکریپت
	// به پیام‌های بقیه‌ی ماژول‌ها هم واکنش نشون میداد.
	if (e.data.id !== 'seatbelt') return;

	$("#seatbeltContainer").stop(false, true);
	if (e.data.display === true) {
		$("#seatbeltContainer").css('display', 'flex');
		$("#seatbeltContainer").animate({
			bottom: "25%",
			opacity: "1.0"
		}, 700);
	} else {
		$("#seatbeltContainer").animate({
			bottom: "-50%",
			opacity: "0.0"
		}, 700, function () {
			$("#seatbeltContainer").css('display', 'none');
		});
	}
});
