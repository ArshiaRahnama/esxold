window.addEventListener('message', function (e) {
    const d = e.data;
    if (!d || d.id !== 'carhud') return;

    const container = document.getElementById('carhudContainer');
    if (!container) return;

    if (d.display === false) {
        container.style.display = 'none';
        return;
    }

    container.style.display = 'block';

    document.getElementById('chSpeedNum').textContent = d.speed ?? 0;
    document.getElementById('chSpeedUnit').textContent = (d.unit || 'kmh').toUpperCase();

    const rpmPercent = Math.max(0, Math.min(100, d.rpm ?? 0));
    document.getElementById('chRpmFill').style.width = rpmPercent + '%';

    const fuelRow = document.getElementById('chFuelRow');
    if (d.fuel === null || d.fuel === undefined) {
        fuelRow.style.display = 'none';
    } else {
        fuelRow.style.display = 'flex';
        const fuelFill = document.getElementById('chFuelFill');
        fuelFill.style.width = Math.max(0, Math.min(100, d.fuel)) + '%';
        fuelFill.classList.toggle('low', d.fuel < 20);
    }
});
