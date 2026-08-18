(function () {
	'use strict';

	const board = document.getElementById('board');
	const topbarLabel = document.getElementById('topbarLabel');
	const liveDot = document.getElementById('liveDot');

	const tabCases = document.getElementById('tabCases');
	const tabWanted = document.getElementById('tabWanted');
	const tabBolo = document.getElementById('tabBolo');
	const tabBooking = document.getElementById('tabBooking');
	const tabRecords = document.getElementById('tabRecords');
	const tabLeaderboard = document.getElementById('tabLeaderboard');

	const caseList = document.getElementById('caseList');
	const emptyState = document.getElementById('emptyState');
	const caseContent = document.getElementById('caseContent');
	const caseTitle = document.getElementById('caseTitle');
	const caseStatus = document.getElementById('caseStatus');
	const warrantPill = document.getElementById('warrantPill');
	const evidenceList = document.getElementById('evidenceList');
	const notesList = document.getElementById('notesList');
	const noteInput = document.getElementById('noteInput');
	const referButtons = document.getElementById('referButtons');
	const matchRow = document.getElementById('matchRow');
	const warrantRow = document.getElementById('warrantRow');
	const closeRow = document.getElementById('closeRow');
	const wantedList = document.getElementById('wantedList');

	const boloList = document.getElementById('boloList');
	const checkVehicleBtn = document.getElementById('checkVehicleBtn');
	const plateResult = document.getElementById('plateResult');

	const bookingTargetId = document.getElementById('bookingTargetId');
	const bookingCaseId = document.getElementById('bookingCaseId');
	const bookingSuspect = document.getElementById('bookingSuspect');
	const bookingCharges = document.getElementById('bookingCharges');
	const bookingFine = document.getElementById('bookingFine');
	const bookingJail = document.getElementById('bookingJail');
	const submitBookingBtn = document.getElementById('submitBookingBtn');

	const recordsList = document.getElementById('recordsList');
	const investigatorsList = document.getElementById('investigatorsList');
	const officersList = document.getElementById('officersList');

	let state = {
		isDojJob: false,
		isLawJob: false,
		isReferralJob: false,
		playerJob: null,
		referralJobs: [],
		cases: [],
		selectedCaseId: null,
		currentTab: null,
	};

	const STATUS_LABELS = {
		open: 'Baz',
		cold: 'Sard Shode',
		referred_judge: 'Ersal Be Judge',
		referred_cia: 'Ersal Be CIA',
		referred_fbi: 'Ersal Be FBI',
		closed: 'Baste Shode',
	};

	const WARRANT_LABELS = {
		requested: 'Hokm: Darkhast Shode',
		approved: 'Hokm: Tayid Shode',
		denied: 'Hokm: Rad Shode',
	};

	const TYPE_LABELS = {
		hint: 'Sarnakh',
		vehicle: 'Khodro',
		strong_lead: 'Sarnakhe Ghavi',
	};

	function statusClass(status) {
		if (status === 'open') return 'open';
		if (status === 'cold') return 'cold';
		if (status === 'closed') return 'closed';
		if (status && status.indexOf('referred_') === 0) return 'referred';
		return '';
	}

	function post(name, data) {
		return fetch(`https://${resourceName()}/${name}`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json; charset=UTF-8' },
			body: JSON.stringify(data || {}),
		}).catch(() => {});
	}

	function resourceName() {
		return window.GetParentResourceName ? window.GetParentResourceName() : 'Unique_CrimeScene';
	}

	function escapeHtml(str) {
		if (str === null || str === undefined) return '';
		return String(str)
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;');
	}

	// ===== Tiny synthesized beep (no audio files needed) =====

	let audioCtx = null;
	function beep(freq, duration, type) {
		try {
			audioCtx = audioCtx || new (window.AudioContext || window.webkitAudioContext)();
			const osc = audioCtx.createOscillator();
			const gain = audioCtx.createGain();
			osc.type = type || 'square';
			osc.frequency.value = freq;
			gain.gain.value = 0.06;
			osc.connect(gain);
			gain.connect(audioCtx.destination);
			osc.start();
			gain.gain.exponentialRampToValueAtTime(0.0001, audioCtx.currentTime + duration);
			osc.stop(audioCtx.currentTime + duration);
		} catch (e) { /* audio not available, ignore */ }
	}

	function playMatchSound() {
		beep(880, 0.12, 'square');
		setTimeout(() => beep(1180, 0.15, 'square'), 130);
	}

	function playSirenBlip() {
		beep(660, 0.1, 'sawtooth');
	}

	// ===== Rendering: Cases =====

	function renderCaseList() {
		caseList.innerHTML = '';
		if (!state.cases.length) {
			caseList.innerHTML = '<div class="sidebar-empty">Parvandei Vojod Nadarad</div>';
			return;
		}
		state.cases.forEach((c) => {
			const el = document.createElement('div');
			el.className = 'case-item' + (c.id === state.selectedCaseId ? ' selected' : '');
			el.innerHTML = `
				<div class="case-item-title">Parvande #${c.id} - ${escapeHtml(c.rob_name)}</div>
				<div class="case-item-status">${STATUS_LABELS[c.status] || c.status}</div>
			`;
			el.addEventListener('click', () => selectCase(c.id));
			caseList.appendChild(el);
		});
	}

	function selectCase(id) {
		state.selectedCaseId = id;
		renderCaseList();
		post('selectCase', { id });
	}

	function renderCaseDetail(data) {
		if (!data) {
			emptyState.classList.remove('hidden');
			caseContent.classList.add('hidden');
			return;
		}

		emptyState.classList.add('hidden');
		caseContent.classList.remove('hidden');

		caseTitle.textContent = `Parvande #${data.case.id} - ${data.case.rob_name}`;
		caseStatus.textContent = STATUS_LABELS[data.case.status] || data.case.status;
		caseStatus.className = 'status-pill ' + statusClass(data.case.status);

		if (data.case.warrant_status && data.case.warrant_status !== 'none') {
			warrantPill.textContent = WARRANT_LABELS[data.case.warrant_status] || data.case.warrant_status;
			warrantPill.className = 'status-pill warrant-' + data.case.warrant_status;
			warrantPill.classList.remove('hidden');
		} else {
			warrantPill.classList.add('hidden');
		}

		evidenceList.innerHTML = '';
		if (!data.evidence.length) {
			evidenceList.innerHTML = '<div class="empty-note">Hanoz Madraki Peida Nashode</div>';
		} else {
			data.evidence.forEach((ev) => {
				const el = document.createElement('div');
				el.className = 'evidence-card';
				el.innerHTML = `
					<div class="evidence-type">${TYPE_LABELS[ev.type] || ev.type}</div>
					<div>${escapeHtml(ev.content)}</div>
					<div class="evidence-meta">Peida Konande: ${escapeHtml(ev.found_by_name || '?')}</div>
				`;
				evidenceList.appendChild(el);
			});
		}

		notesList.innerHTML = '';
		if (!data.notes.length) {
			notesList.innerHTML = '<div class="empty-note">Yaddashti Sabt Nashode</div>';
		} else {
			data.notes.forEach((n) => {
				const el = document.createElement('div');
				el.className = 'note-item' + (n.author === 'SYSTEM' ? ' system' : '');
				el.innerHTML = `
					<div>${escapeHtml(n.note)}</div>
					<div class="note-author">${escapeHtml(n.author_name || '?')}</div>
				`;
				notesList.appendChild(el);
			});
		}

		referButtons.innerHTML = '';
		matchRow.innerHTML = '';
		warrantRow.innerHTML = '';
		closeRow.innerHTML = '';

		const openLike = data.case.status === 'open' || data.case.status === 'cold';
		const warrantStatus = data.case.warrant_status || 'none';

		if (openLike) {
			state.referralJobs.forEach((job) => {
				const btn = document.createElement('button');
				btn.className = 'btn btn-outline';
				btn.textContent = 'Ersal Be ' + job.toUpperCase();
				btn.addEventListener('click', () => post('referCase', { id: data.case.id, job }));
				referButtons.appendChild(btn);
			});

			const matchBtn = document.createElement('button');
			matchBtn.className = 'btn btn-gold';
			matchBtn.textContent = 'Tatbighe Asare Angosht';
			matchBtn.addEventListener('click', () => post('runMatch', { id: data.case.id }));
			matchRow.appendChild(matchBtn);

			const hasVehicleEvidence = data.evidence.some((ev) => ev.type === 'vehicle');
			if (hasVehicleEvidence) {
				const boloBtn = document.createElement('button');
				boloBtn.className = 'btn btn-outline';
				boloBtn.textContent = 'Sodore BOLO';
				boloBtn.addEventListener('click', () => post('issueBOLO', { id: data.case.id }));
				matchRow.appendChild(boloBtn);
			}

			if (warrantStatus === 'none' || warrantStatus === 'denied') {
				const warrantBtn = document.createElement('button');
				warrantBtn.className = 'btn btn-outline';
				warrantBtn.textContent = 'Darkhaste Hokme Bazdasht';
				warrantBtn.addEventListener('click', () => post('requestWarrant', { id: data.case.id }));
				warrantRow.appendChild(warrantBtn);
			}
		}

		if (state.playerJob === 'judge' && warrantStatus === 'requested') {
			const approveBtn = document.createElement('button');
			approveBtn.className = 'btn btn-primary';
			approveBtn.textContent = 'Tayide Hokm';
			approveBtn.addEventListener('click', () => post('decideWarrant', { id: data.case.id, approved: true }));
			warrantRow.appendChild(approveBtn);

			const denyBtn = document.createElement('button');
			denyBtn.className = 'btn btn-outline';
			denyBtn.textContent = 'Rade Hokm';
			denyBtn.addEventListener('click', () => post('decideWarrant', { id: data.case.id, approved: false }));
			warrantRow.appendChild(denyBtn);
		}

		if (state.isReferralJob && data.case.status === ('referred_' + state.playerJob)) {
			const verdictBtn = document.createElement('button');
			verdictBtn.className = 'btn btn-primary';
			verdictBtn.textContent = 'Baste Kardane Parvande + Hokm';
			verdictBtn.addEventListener('click', () => {
				const verdict = prompt('Hokm / Natijeye Parvande:') || '';
				post('closeCase', { id: data.case.id, verdict });
			});
			closeRow.appendChild(verdictBtn);
		}
	}

	// ===== Rendering: Wanted =====

	function renderWanted(list) {
		wantedList.innerHTML = '';
		if (!list.length) {
			wantedList.innerHTML = '<div class="empty-note">Hich Kode Takrari Sabt Nashode</div>';
			return;
		}
		list.forEach((row) => {
			const el = document.createElement('div');
			el.className = 'wanted-card';
			el.innerHTML = `
				<div class="wanted-code">#${escapeHtml(row.suspect_hint_id)}</div>
				<div class="wanted-hits">Tedade Sarnakh: <b>${row.hits}</b></div>
				<div class="wanted-last">Akharin Moshahede: ${escapeHtml(row.last_seen || '?')}</div>
			`;
			wantedList.appendChild(el);
		});
	}

	// ===== Rendering: BOLO =====

	function renderBolos(list) {
		boloList.innerHTML = '';
		if (!list.length) {
			boloList.innerHTML = '<div class="empty-note">Hich BOLO-i Faal Nist</div>';
			return;
		}
		list.forEach((row) => {
			const el = document.createElement('div');
			el.className = 'bolo-card';
			el.innerHTML = `
				<div class="bolo-plate">${escapeHtml(row.plate)}</div>
				<div class="bolo-meta">Parvande #${row.caseId} - Sader Konande: ${escapeHtml(row.issuedBy || '?')}</div>
			`;
			boloList.appendChild(el);
		});
	}

	// ===== Rendering: Records =====

	function renderRecords(list) {
		recordsList.innerHTML = '';
		if (!list.length) {
			recordsList.innerHTML = '<div class="empty-note">Hich Sabeghei Sabt Nashode</div>';
			return;
		}
		list.forEach((row) => {
			const el = document.createElement('div');
			el.className = 'record-card';
			const caseTag = row.case_id ? ` &middot; Parvande #${row.case_id}` : '';
			el.innerHTML = `
				<div class="record-suspect">${escapeHtml(row.suspect_name)}${caseTag}</div>
				<div class="record-charges">${escapeHtml(row.charges)}</div>
				<div class="record-meta">
					<span>Jarime: <b>$${escapeHtml(row.fine)}</b></span>
					<span>Zendan: <b>${escapeHtml(row.jail_minutes)} Daghighe</b></span>
					<span>Afsar: ${escapeHtml(row.booked_by_name || '?')}</span>
				</div>
			`;
			recordsList.appendChild(el);
		});
	}

	// ===== Rendering: Leaderboard =====

	function renderLeaderboardList(container, list, emptyText) {
		container.innerHTML = '';
		if (!list.length) {
			container.innerHTML = `<div class="empty-note">${emptyText}</div>`;
			return;
		}
		list.forEach((row, i) => {
			const el = document.createElement('div');
			el.className = 'leaderboard-item';
			el.innerHTML = `
				<div class="leaderboard-rank">#${i + 1}</div>
				<div class="leaderboard-name">${escapeHtml(row.name)}</div>
				<div class="leaderboard-score">${row.score}</div>
			`;
			container.appendChild(el);
		});
	}

	function renderLeaderboard(data) {
		renderLeaderboardList(investigatorsList, data.investigators || [], 'Hanoz Amari Sabt Nashode');
		renderLeaderboardList(officersList, data.officers || [], 'Hanoz Amari Sabt Nashode');
	}

	function showPlateResult(found, noVehicle) {
		plateResult.classList.remove('hidden', 'match', 'clean');
		if (noVehicle) {
			plateResult.textContent = 'Khodroi Dar In Nazdiki Peida Nashod';
			plateResult.classList.add('clean');
		} else if (found) {
			plateResult.textContent = '🚨 MATCH! In Khodro BOLO Darad';
			plateResult.classList.add('match');
			playMatchSound();
		} else {
			plateResult.textContent = '✔ Pak Ast - Hich BOLO-i Baraye In Pelak Nist';
			plateResult.classList.add('clean');
		}
		setTimeout(() => plateResult.classList.add('hidden'), 6000);
	}

	checkVehicleBtn.addEventListener('click', () => {
		checkVehicleBtn.disabled = true;
		post('checkNearestVehicle', {});
		setTimeout(() => { checkVehicleBtn.disabled = false; }, 1500);
	});

	submitBookingBtn.addEventListener('click', () => {
		const suspectName = bookingSuspect.value.trim();
		const charges = bookingCharges.value.trim();

		if (!suspectName || !charges) {
			alert('Esme Mozan Va Ettehamat Alzami Ast');
			return;
		}

		post('createBooking', {
			targetServerId: bookingTargetId.value ? parseInt(bookingTargetId.value, 10) : null,
			caseId: bookingCaseId.value ? parseInt(bookingCaseId.value, 10) : null,
			suspectName,
			charges,
			fine: bookingFine.value ? parseInt(bookingFine.value, 10) : 0,
			jailMinutes: bookingJail.value ? parseInt(bookingJail.value, 10) : 0,
		});

		bookingTargetId.value = '';
		bookingCaseId.value = '';
		bookingSuspect.value = '';
		bookingCharges.value = '';
		bookingFine.value = '';
		bookingJail.value = '';
	});

	// ===== Tabs =====

	function switchTab(tab) {
		tabCases.classList.toggle('active', tab === 'cases');
		tabWanted.classList.toggle('active', tab === 'wanted');
		tabBolo.classList.toggle('active', tab === 'bolo');
		tabBooking.classList.toggle('active', tab === 'booking');
		tabRecords.classList.toggle('active', tab === 'records');
		tabLeaderboard.classList.toggle('active', tab === 'leaderboard');

		document.getElementById('viewCases').classList.toggle('active', tab === 'cases');
		document.getElementById('viewWanted').classList.toggle('active', tab === 'wanted');
		document.getElementById('viewBolo').classList.toggle('active', tab === 'bolo');
		document.getElementById('viewBooking').classList.toggle('active', tab === 'booking');
		document.getElementById('viewRecords').classList.toggle('active', tab === 'records');
		document.getElementById('viewLeaderboard').classList.toggle('active', tab === 'leaderboard');

		state.currentTab = tab;

		if (tab === 'wanted') post('loadWanted', {});
		if (tab === 'bolo') post('loadBolos', {});
		if (tab === 'records') post('loadRecords', {});
		if (tab === 'leaderboard') post('loadLeaderboard', {});

		topbarLabel.textContent = (tab === 'bolo' || tab === 'booking') ? 'LAW ENFORCEMENT // ' + tab.toUpperCase() : 'DOJ // ' + tab.toUpperCase();
	}

	tabCases.addEventListener('click', () => switchTab('cases'));
	tabWanted.addEventListener('click', () => switchTab('wanted'));
	tabBolo.addEventListener('click', () => switchTab('bolo'));
	tabBooking.addEventListener('click', () => switchTab('booking'));
	tabRecords.addEventListener('click', () => switchTab('records'));
	tabLeaderboard.addEventListener('click', () => switchTab('leaderboard'));

	// ===== Actions =====

	document.getElementById('addNoteBtn').addEventListener('click', () => {
		const text = noteInput.value.trim();
		if (!text || !state.selectedCaseId) return;
		post('addNote', { id: state.selectedCaseId, note: text });
		noteInput.value = '';
	});

	document.getElementById('closeBtn').addEventListener('click', closeBoard);

	function closeBoard() {
		board.classList.add('hidden');
		post('close', {});
	}

	window.addEventListener('keydown', (e) => {
		if (e.key === 'Escape' && !board.classList.contains('hidden')) {
			closeBoard();
		}
	});

	// ===== Messages from Lua =====

	window.addEventListener('message', (event) => {
		const msg = event.data;
		if (!msg || !msg.action) return;

		switch (msg.action) {
			case 'open': {
				state.isDojJob = !!msg.isDojJob;
				state.isLawJob = !!msg.isLawJob;
				state.isReferralJob = !!msg.isReferralJob;
				state.playerJob = msg.playerJob || null;
				state.referralJobs = msg.referralJobs || [];
				state.selectedCaseId = null;

				tabCases.classList.toggle('hidden', !state.isDojJob);
				tabWanted.classList.toggle('hidden', !state.isDojJob);
				tabBolo.classList.toggle('hidden', !state.isLawJob);
				tabBooking.classList.toggle('hidden', !state.isLawJob);
				tabRecords.classList.toggle('hidden', !(state.isDojJob || state.isLawJob));
				tabLeaderboard.classList.toggle('hidden', !(state.isDojJob || state.isLawJob));

				board.classList.remove('hidden');
				switchTab(state.isDojJob ? 'cases' : 'bolo');

				emptyState.classList.remove('hidden');
				caseContent.classList.add('hidden');
				plateResult.classList.add('hidden');
				break;
			}

			case 'close':
				board.classList.add('hidden');
				break;

			case 'cases':
				state.cases = msg.cases || [];
				renderCaseList();
				break;

			case 'caseDetail':
				renderCaseDetail(msg.data);
				break;

			case 'wanted':
				renderWanted(msg.list || []);
				break;

			case 'bolos':
				renderBolos(msg.list || []);
				break;

			case 'records':
				renderRecords(msg.list || []);
				break;

			case 'leaderboard':
				renderLeaderboard(msg.data || { investigators: [], officers: [] });
				break;

			case 'recordsStale':
				if (state.currentTab === 'records') post('loadRecords', {});
				break;

			case 'boloAlert':
				playSirenBlip();
				break;

			case 'plateCheckResult':
				showPlateResult(msg.found, msg.noVehicle);
				break;
		}
	});
})();
