document.addEventListener('DOMContentLoaded', function () {
  const tabs = document.querySelectorAll('.tab');
  const panels = {
    quests: document.getElementById('tab_quests'),
    collections: document.getElementById('tab_collections'),
  };

  function activateTab(tabName) {
    Object.keys(panels).forEach(key => {
      panels[key].classList.toggle('hidden', key !== tabName);
    });
    tabs.forEach(t => t.classList.toggle('active', t.dataset.tab === tabName));
  }

  tabs.forEach(tabBtn => {
    tabBtn.addEventListener('click', function () {
      activateTab(this.dataset.tab);
    });
  });

  const subtabs = document.querySelectorAll('.subtab');
  const subpanels = {
    vehicles: document.getElementById('sub_vehicles'),
    houses: document.getElementById('sub_houses'),
  };

  function activateSubtab(subName) {
    Object.keys(subpanels).forEach(key => {
      subpanels[key].classList.toggle('hidden', key !== subName);
    });
    subtabs.forEach(t => t.classList.toggle('active', t.dataset.sub === subName));
  }

  subtabs.forEach(subBtn => {
    subBtn.addEventListener('click', function () {
      activateSubtab(this.dataset.sub);
    });
  });

  window.addEventListener('message', function (event) {
    const data = event.data;
    const container = document.querySelector('.container');
    if (!container) return;

    switch (data.type) {
      case 'openMenu':
        container.style.display = 'flex';
        activateTab('quests');
        activateSubtab('vehicles');
        break;

      case 'closeMenu':
        container.style.display = 'none';
        break;
    }
  });

  document.addEventListener('keydown', (event) => {
    const container = document.querySelector('.container');
    if (!container) return;

    if (event.key === 'Escape' || event.key === 'Backspace') {
      container.style.display = 'none';

      const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'unknown_resource';

      fetch(`https://${resourceName}/menuClosed`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'menuClosed' }),
      });
    }
  });
});
