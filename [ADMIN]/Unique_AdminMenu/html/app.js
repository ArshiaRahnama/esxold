let resourceName = 'Unique_AdminMenu';
let currentChatLog = [];
let currentReports = [];

function post(endpoint, data) {
  fetch(`https://${resourceName}/${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data || {})
  }).catch(() => {});
}

// ============================================================================
// STATS WIDGET
// ============================================================================
function renderStats(data) {
  document.getElementById('statsWidget').classList.remove('hidden');
  document.getElementById('statsOnline').textContent = `${data.online}/${data.maxPlayers}`;
  const mins = Math.floor(data.uptimeSeconds / 60);
  const hrs = Math.floor(mins / 60);
  document.getElementById('statsUptime').textContent = hrs > 0 ? `${hrs}h ${mins % 60}m` : `${mins}m`;
  document.getElementById('statsReports').textContent = data.openReports ?? 0;
  document.getElementById('statsReportsRow').classList.toggle('hasOpen', (data.openReports ?? 0) > 0);
}
// Note: this row is display-only, not clickable - the always-on stats
// widget renders without NUI focus (so it never blocks mouse/keyboard
// control of the game), and FiveM only delivers click events to NUI while
// focus is active. Use the "Report Queue" button in Server Tools to open
// the full list.

// ============================================================================
// PANEL: INSPECT / REPORTS / CHATLOG
// ============================================================================
function openPanel(title, showSearch) {
  document.getElementById('panel').classList.remove('hidden');
  document.getElementById('panelTitle').textContent = title;
  document.getElementById('panelSearchWrap').classList.toggle('hidden', !showSearch);
  document.getElementById('panelSearch').value = '';
}

function closePanel() {
  document.getElementById('panel').classList.add('hidden');
  post('closePanel');
}

function renderInspect(data) {
  openPanel(`Inspect: ${data.name} (id: ${data.source})`, false);
  const rows = [
    ['Identifier', data.identifier],
    ['Job', data.job ? `${data.job.label || data.job.name} (grade ${data.job.grade})` : 'n/a'],
    ['Cash', data.money ?? 'n/a'],
    ['Bank', data.bank ?? 'n/a'],
    ['Permission Level', data.permission_level ?? '0'],
    ['Ping', data.ping ?? 'n/a'],
    ['Inventory Items', data.inventory ? data.inventory.length : 'n/a'],
  ];
  document.getElementById('panelBody').innerHTML = rows.map(([k, v]) =>
    `<div class="infoRow"><span>${k}</span><span>${v}</span></div>`
  ).join('');
}

function renderReports(reports) {
  // `reports` comes from esx_aduty as an object keyed by report id, e.g.
  // { "3": { owner:{name,id}, category, Detail, status, time }, ... } -
  // not an array, so it's normalized to a list here first.
  currentReports = Object.keys(reports || {}).map(id => ({ id, ...reports[id] }));
  openPanel(`Report Queue (${currentReports.filter(r => r.status === 'open').length} open)`, true);
  drawReports(currentReports);
}
function drawReports(list) {
  if (!list.length) {
    document.getElementById('panelBody').innerHTML = '<div class="infoRow"><span>No open reports</span></div>';
    return;
  }
  document.getElementById('panelBody').innerHTML = list.map(r => `
    <div class="reportCard status-${escapeHtml(r.status || 'open')}">
      <div class="rTitle">${escapeHtml(r.owner ? r.owner.name : 'Unknown')} (id: ${r.owner ? r.owner.id : '?'}) - ${escapeHtml(r.category || '')}</div>
      <div class="rMeta">${escapeHtml(r.Detail || '')}</div>
      <div class="rMeta">status: <span class="statusTag status-${escapeHtml(r.status || 'open')}">${escapeHtml(r.status || 'open')}</span>${r.respond && r.respond.name !== 'none' ? ' | handled by: ' + escapeHtml(r.respond.name) : ''}</div>
      <div class="rActions">
        ${r.status === 'open' ? `<button class="rBtn accept" data-id="${escapeHtml(r.id)}">Accept</button>` : ''}
        ${r.status === 'pending' ? `<button class="rBtn close" data-id="${escapeHtml(r.id)}">Close</button>` : ''}
      </div>
    </div>
  `).join('');

  document.querySelectorAll('.rBtn.accept').forEach(btn => {
    btn.addEventListener('click', () => post('reportAction', { id: btn.dataset.id, action: 'accept' }));
  });
  document.querySelectorAll('.rBtn.close').forEach(btn => {
    btn.addEventListener('click', () => post('reportAction', { id: btn.dataset.id, action: 'close' }));
  });
}

function renderChatLog(log) {
  currentChatLog = log || [];
  openPanel('Chat Log', true);
  drawChatLog(currentChatLog);
}
function drawChatLog(list) {
  if (!list.length) {
    document.getElementById('panelBody').innerHTML = '<div class="infoRow"><span>No chat messages yet</span></div>';
    return;
  }
  document.getElementById('panelBody').innerHTML = list.slice().reverse().map(m => `
    <div class="logLine"><span class="who">${escapeHtml(m.name)}</span><span class="time">${m.time}</span><br>${escapeHtml(m.message)}</div>
  `).join('');
}

function escapeHtml(str) {
  const d = document.createElement('div');
  d.textContent = String(str ?? '');
  return d.innerHTML;
}

document.getElementById('panelClose').addEventListener('click', closePanel);
document.getElementById('panelSearch').addEventListener('input', (e) => {
  const q = e.target.value.toLowerCase();
  if (document.getElementById('panelTitle').textContent === 'Chat Log') {
    drawChatLog(currentChatLog.filter(m =>
      (m.message || '').toLowerCase().includes(q) || (m.name || '').toLowerCase().includes(q)
    ));
  } else if (document.getElementById('panelTitle').textContent.startsWith('Report Queue')) {
    drawReports(currentReports.filter(r =>
      ((r.Detail || '') + (r.owner ? r.owner.name : '') + (r.category || '')).toLowerCase().includes(q)
    ));
  }
});

// ============================================================================
// RADIAL QUICK-ACTIONS MENU
// ============================================================================
const RadialActions = [
  { id: 'freeze',  label: 'Freeze Nearest' },
  { id: 'heal',    label: 'Heal Self' },
  { id: 'revive',  label: 'Revive Self' },
  { id: 'spawncar',label: 'Spawn Car' },
  { id: 'tpwp',    label: 'TP Waypoint' },
  { id: 'fixcar',  label: 'Fix Vehicle' },
];

function buildRadial() {
  const ring = document.getElementById('radialRing');
  ring.innerHTML = '';
  const n = RadialActions.length;
  const radius = 120;
  RadialActions.forEach((a, i) => {
    const angle = (i / n) * 2 * Math.PI - Math.PI / 2;
    const x = 160 + radius * Math.cos(angle) - 55;
    const y = 160 + radius * Math.sin(angle) - 23;
    const el = document.createElement('div');
    el.className = 'radialSlice';
    el.style.left = `${x}px`;
    el.style.top = `${y}px`;
    el.textContent = a.label;
    el.addEventListener('click', () => {
      post('radialAction', { action: a.id });
      hideRadial();
    });
    ring.appendChild(el);
  });
}

function showRadial() {
  buildRadial();
  document.getElementById('radial').classList.remove('hidden');
}
function hideRadial() {
  document.getElementById('radial').classList.add('hidden');
  post('closeRadial');
}

// ============================================================================
// NEW-REPORT TOAST
// ============================================================================
let toastTimer = null;
function showToast(count) {
  let toast = document.getElementById('reportToast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'reportToast';
    document.body.appendChild(toast);
  }
  toast.textContent = count > 1 ? `${count} New Reports!` : 'New Report!';
  toast.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => toast.classList.remove('show'), 4000);
}

// ============================================================================
// MESSAGE ROUTER (from Lua)
// ============================================================================
window.addEventListener('message', (event) => {
  const { type, data, count } = event.data;
  switch (type) {
    case 'stats': renderStats(data); break;
    case 'inspect': renderInspect(data); break;
    case 'reports': renderReports(data); break;
    case 'chatlog': renderChatLog(data); break;
    case 'showRadial': showRadial(); break;
    case 'hideRadial': hideRadial(); break;
    case 'newReportAlert': showToast(count); break;
  }
});

document.addEventListener('keyup', (e) => {
  if (e.key === 'Escape') {
    closePanel();
    hideRadial();
  }
});
