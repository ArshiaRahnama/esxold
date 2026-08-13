function lbPost(callbackName, body) {
    fetch(`https://${GetParentResourceName()}/${callbackName}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body || {})
    });
}

function lbRender(data) {
    const container = document.getElementById('leaderboardContainer');
    container.style.display = 'flex';

    document.querySelectorAll('.lbTab').forEach(t => {
        t.classList.toggle('active', t.dataset.mode === data.mode);
    });

    const skillRow = document.getElementById('lbSkillRow');
    if (data.mode === 'skill') {
        skillRow.style.display = 'flex';
        skillRow.innerHTML = (data.skillList || []).map(s =>
            `<div class="lbSkillChip ${s === data.skill ? 'active' : ''}" data-skill="${s}">${s}</div>`
        ).join('');
    } else {
        skillRow.style.display = 'none';
    }

    const list = document.getElementById('lbList');
    if (!data.rows || data.rows.length === 0) {
        list.innerHTML = '<div class="lbEmpty">هنوز داده‌ای نیست</div>';
    } else {
        list.innerHTML = data.rows.map(r => `
            <div class="lbRow ${r.rank <= 3 ? 'top' + r.rank : ''}">
                <div class="lbRank">${r.rank}</div>
                <div class="lbName">${r.name}</div>
                <div class="lbValue">${r.value}</div>
            </div>
        `).join('');
    }
}

window.addEventListener('message', function (e) {
    const d = e.data;
    if (!d) return;

    if (d.id === 'lbButton') {
        const btn = document.getElementById('lbFloatButton');
        if (btn) btn.style.display = d.show ? 'flex' : 'none';
        return;
    }

    if (d.id !== 'leaderboard') return;

    if (d.display === false) {
        document.getElementById('leaderboardContainer').style.display = 'none';
        return;
    }
    lbRender(d);
});

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.lbTab').forEach(tab => {
        tab.addEventListener('click', () => {
            lbPost('leaderboard:setMode', { mode: tab.dataset.mode, skill: 'Police' });
        });
    });

    document.getElementById('lbSkillRow').addEventListener('click', (ev) => {
        const chip = ev.target.closest('.lbSkillChip');
        if (!chip) return;
        lbPost('leaderboard:setMode', { mode: 'skill', skill: chip.dataset.skill });
    });

    document.getElementById('lbClose').addEventListener('click', () => {
        lbPost('leaderboard:close', {});
        document.getElementById('leaderboardContainer').style.display = 'none';
    });

    document.getElementById('lbFloatButton').addEventListener('click', () => {
        lbPost('leaderboard:openFromButton', {});
    });
});

document.addEventListener('keydown', (ev) => {
    if (ev.key === 'Escape' && document.getElementById('leaderboardContainer').style.display === 'flex') {
        lbPost('leaderboard:close', {});
        document.getElementById('leaderboardContainer').style.display = 'none';
    }
});
