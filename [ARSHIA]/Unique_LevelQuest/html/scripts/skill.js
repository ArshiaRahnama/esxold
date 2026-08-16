function sortByPercentage(items) {
  if (!items || !Array.isArray(items)) return [];
  return [...items].sort((a, b) => (Number(b.value) || 0) - (Number(a.value) || 0));
}

document.addEventListener('DOMContentLoaded', () => {
  const skillList = document.querySelector('.skill-list');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'loadSkills' && Array.isArray(data.skills)) {
      skillList.innerHTML = '';
      const sorted = sortByPercentage(data.skills);

      sorted.forEach(s => {
        const pct = Math.max(0, Math.min(100, (Number(s.value) || 0) * 100));
        const row = document.createElement('div');
        row.className = 'skillRow';
        row.innerHTML = `
          <div class="skillTop">
            <span class="skillTitle">${s.title}</span>
            <span class="skillPct">${pct.toFixed(1)}%</span>
          </div>
          <div class="skillBar">
            <div class="skillFill" style="width:0%"></div>
          </div>
        `;
        skillList.appendChild(row);

        const fill = row.querySelector('.skillFill');
        requestAnimationFrame(() => { fill.style.width = `${pct}%`; });
      });
    }
  });
});
