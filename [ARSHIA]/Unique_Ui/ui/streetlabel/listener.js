let oldHud = true;

window.addEventListener('message', function (event) {
	const item = event.data;
	if (!item || item.id !== 'streetlabel') return;

	if (item.hud !== oldHud) {
		oldHud = item.hud;
		if (item.hud) {
			$("#streetlabelContainer").css({ "bottom": "5vh" });
		} else {
			$("#streetlabelContainer").css({ "bottom": "87vh" });
		}
	}

	if (!item.active) {
		$("#sl").hide();
	} else {
		$("#sl").show();
	}

	$('#timestamp').text(item.time);
	$('#timestamp2').text(item.ts);
	$('#src').text(item.src);
	$('#server').text(item.server);
	$('#direction').text(item.direction);
	$('#zone').text(item.zone);
	$('#street').text(item.street);
});
