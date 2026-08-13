window.addEventListener('message', function (e) {
    const d = e.data;
    if (!d || d.id !== 'toast') return;

    const container = document.getElementById('toastContainer');
    if (!container) return;

    const card = document.createElement('div');
    card.className = 'toastCard';
    card.innerHTML = `
        <div class="toastIcon">${d.kind === 'skill' ? '⚡' : '🏆'}</div>
        <div class="toastText">
            <div class="toastTitle">${d.title || ''}</div>
            <div class="toastSubtitle">${d.subtitle || ''}</div>
        </div>
    `;
    container.appendChild(card);

    requestAnimationFrame(() => card.classList.add('show'));

    setTimeout(() => {
        card.classList.remove('show');
        setTimeout(() => card.remove(), 400);
    }, 4500);
});
