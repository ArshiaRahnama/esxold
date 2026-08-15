document.addEventListener('DOMContentLoaded', function () {
  const tabs = document.querySelectorAll('.tab');
  const panels = {
    quests: document.getElementById('tab_quests'),
    dispatch: document.getElementById('tab_dispatch'),
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

  window.addEventListener('message', function (event) {
    const data = event.data;
    const container = document.querySelector('.container');
    if (!container) return;

    switch (data.type) {
      case 'openMenu':
        container.style.display = 'flex';
        activateTab('quests');
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
