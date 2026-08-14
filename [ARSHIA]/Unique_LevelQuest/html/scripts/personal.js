// Levl bar Animations Az Samte Lua Mehdi
function animateXpBar(fillElement, targetPercent, duration = 1000) {
  const currentWidth = parseInt(fillElement.style.width) || 0;
  const startTime = performance.now();

  const animate = (now) => {
    const elapsed = now - startTime;
    const progress = Math.min(elapsed / duration, 1);
    const newWidth = Math.round(currentWidth + (targetPercent - currentWidth) * progress);

    fillElement.style.width = newWidth + '%';

    if (progress < 1) {
      requestAnimationFrame(animate);
    }
  };

  requestAnimationFrame(animate);
}

// Event listener az samte Lua Mehdi
document.addEventListener('DOMContentLoaded', () => {
  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'updateProfile') {
      const nameElem = document.querySelector('.main-content .name_span');
      const jobElem = document.querySelector('.main-content .job_span');
      const gangElem = document.querySelector('.main-content .gang_span');
      const cashElem = document.querySelector('.main-content .cash_span');
      const bankElem = document.querySelector('.main-content .bank_span');
      const coinElem = document.querySelector('.main-content .coin_span');
      const levelElem = document.querySelector('.main-content .level-number');
      const xpFillElem = document.querySelector('.main-content .xp-fill');

      if (nameElem) nameElem.textContent = data.name || 'Unknown';
      if (jobElem) jobElem.textContent = data.job || 'Unknown';
      if (gangElem) gangElem.textContent = data.gang || 'Unknown';
      if (cashElem) cashElem.textContent = (data.cash ?? 'Unknown').toLocaleString(); 
      if (bankElem) bankElem.textContent = (data.bank ?? 'Unknown').toLocaleString();
      if (coinElem) coinElem.textContent = data.coin ?? 'Unknown';

      if (levelElem && data.level !== undefined) {
        levelElem.textContent = data.level;
      }

      if (xpFillElem && data.xpPercent !== undefined) {
        const percent = Math.max(0, Math.min(100, parseInt(data.xpPercent)));
        animateXpBar(xpFillElem, percent);
      }
    }
  });
});
