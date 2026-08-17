document.addEventListener('DOMContentLoaded', () => {
  const vehGrid = document.getElementById('veh_grid');
  const vehEmpty = document.getElementById('veh_empty');
  const houseGrid = document.getElementById('house_grid');
  const houseEmpty = document.getElementById('house_empty');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'loadVehicles' && Array.isArray(data.vehicles)) {
      vehGrid.innerHTML = '';
      vehEmpty.classList.toggle('hidden', data.vehicles.length > 0);

      data.vehicles.forEach(v => {
        const card = document.createElement('div');
        card.className = 'imgCard';
        card.innerHTML = `
          <div class="cardIcon"><i class="fa-solid fa-car-side"></i></div>
          <div class="cap">${v.name}<br><small>${v.plate}</small></div>
        `;
        vehGrid.appendChild(card);

        // Real preview images from FiveM's public vehicle database. Not
        // every model is in there (custom/addon cars won't be), so we
        // test-load first and just keep the icon card if it 404s.
        if (v.slug) {
          const cardIcon = card.querySelector('.cardIcon');
          const imgPath = `https://docs.fivem.net/vehicles/${v.slug}.webp`;
          const test = new Image();
          test.onload = () => {
            cardIcon.innerHTML = '';
            cardIcon.style.backgroundImage = `url('${imgPath}')`;
            cardIcon.classList.add('hasVehicleImage');
          };
          test.src = imgPath;
        }
      });
    }

    if (data.type === 'loadHouses' && Array.isArray(data.houses)) {
      houseGrid.innerHTML = '';
      houseEmpty.classList.toggle('hidden', data.houses.length > 0);

      data.houses.forEach(h => {
        const card = document.createElement('div');
        card.className = 'imgCard';
        card.innerHTML = `
          <div class="cardIcon"><i class="fa-solid fa-house"></i></div>
          <div class="cap">${h.name}</div>
        `;
        houseGrid.appendChild(card);
      });
    }
  });
});
