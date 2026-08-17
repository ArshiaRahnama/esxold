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
        card.innerHTML = `<div class="cap">${v.name}<br><small>${v.plate}</small></div>`;

        // Real preview images from FiveM's public vehicle database, using
        // a native <img loading="lazy"> instead of preloading everything
        // up front — the browser only fetches what actually scrolls into
        // view, instead of firing 15-20 requests the instant the menu
        // opens. onerror swaps back to the icon for models that aren't
        // in that database (custom/addon cars).
        let mediaEl;
        if (v.slug) {
          mediaEl = document.createElement('img');
          mediaEl.className = 'cardImg';
          mediaEl.loading = 'lazy';
          mediaEl.src = `https://docs.fivem.net/vehicles/${v.slug}.webp`;
          mediaEl.addEventListener('error', () => {
            const fallback = document.createElement('div');
            fallback.className = 'cardIcon';
            fallback.innerHTML = '<i class="fa-solid fa-car-side"></i>';
            mediaEl.replaceWith(fallback);
          });
        } else {
          mediaEl = document.createElement('div');
          mediaEl.className = 'cardIcon';
          mediaEl.innerHTML = '<i class="fa-solid fa-car-side"></i>';
        }
        card.prepend(mediaEl);

        vehGrid.appendChild(card);
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
