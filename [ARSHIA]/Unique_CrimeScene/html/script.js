(function () {
	'use strict';

	const board = document.getElementById('board');
	const caseList = document.getElementById('caseList');
	const emptyState = document.getElementById('emptyState');
	const caseContent = document.getElementById('caseContent');
	const caseTitle = document.getElementById('caseTitle');
	const caseStatus = document.getElementById('caseStatus');
	const evidenceList = document.getElementById('evidenceList');
	const notesList = document.getElementById('notesList');
	const noteInput = document.getElementById('noteInput');
	const referButtons = document.getElementById('referButtons');
	const matchRow = document.getElementById('matchRow');
	const closeRow = document.getElementById('closeRow');
	const wantedList = document.getElementById('wantedList');

	let state = {
		isReferralJob: false,
		playerJob: null,
		referralJobs: [],
		cases: [],
		selectedCaseId: null,
		selectedCaseStatus: null,
	};

	const STATUS_LABELS = {
		open: 'Baz',
		cold: 'Sard Shode',
		referred_judge: 'Ersal Be Judge',
		referred_cia: 'Ersal Be CIA',
		referred_fbi: 'Ersal Be FBI',
		closed: 'Baste Shode',
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
		return fetch(`https://${GetParentResourceName()}/${name}`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json; charset=UTF-8' },
			body: JSON.stringify(data || {}),
		}).catch(() => {});
	}

	function GetParentResourceName() {
		return window.GetParentResourceName ? window.GetParentResourceName() : 'Unique_CrimeScene';
	}

	// ===== Rendering =====

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

		state.selectedCaseStatus = data.case.status;

		emptyState.classList.add('hidden');
		caseContent.classList.remove('hidden');

		caseTitle.textContent = `Parvande #${data.case.id} - ${data.case.rob_name}`;
		caseStatus.textContent = STATUS_LABELS[data.case.status] || data.case.status;
		caseStatus.className = 'status-pill ' + statusClass(data.case.status);

		// evidence
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

		// notes
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

		// referral buttons
		referButtons.innerHTML = '';
		matchRow.innerHTML = '';
		closeRow.innerHTML = '';

		const openLike = data.case.status === 'open' || data.case.status === 'cold';

		if (openLike) {
			state.referralJobs.forEach((job) => {
				const btn = document.createElement('button');
				btn.className = 'btn btn-outline';
				btn.textContent = 'Ersal Be ' + job.toUpperCase();
				btn.addEventListener('click', () => {
					post('referCase', { id: data.case.id, job });
				});
				referButtons.appendChild(btn);
			});

			const matchBtn = document.createElement('button');
			matchBtn.className = 'btn btn-gold';
			matchBtn.textContent = 'Tatbighe Asare Angosht';
			matchBtn.addEventListener('click', () => {
				post('runMatch', { id: data.case.id });
			});
			matchRow.appendChild(matchBtn);
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

	function escapeHtml(str) {
		if (str === null || str === undefined) return '';
		return String(str)
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;');
	}

	// ===== Tabs =====

	document.getElementById('tabCases').addEventListener('click', () => switchTab('cases'));
	document.getElementById('tabWanted').addEventListener('click', () => switchTab('wanted'));

	function switchTab(tab) {
		document.getElementById('tabCases').classList.toggle('active', tab === 'cases');
		document.getElementById('tabWanted').classList.toggle('active', tab === 'wanted');
		document.getElementById('viewCases').classList.toggle('active', tab === 'cases');
		document.getElementById('viewWanted').classList.toggle('active', tab === 'wanted');
		if (tab === 'wanted') post('loadWanted', {});
	}

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
			case 'open':
				state.isReferralJob = !!msg.isReferralJob;
				state.playerJob = msg.playerJob || null;
				state.referralJobs = msg.referralJobs || [];
				state.selectedCaseId = null;
				board.classList.remove('hidden');
				switchTab('cases');
				emptyState.classList.remove('hidden');
				caseContent.classList.add('hidden');
				break;

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
		}
	});
})();
