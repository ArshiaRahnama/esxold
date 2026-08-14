document.addEventListener('DOMContentLoaded', function() {
  const menuItems = document.querySelectorAll('.menu-item');
  const contents = {
    'personal-info': document.querySelector('.main-content'),
    'quests': document.querySelector('.quests'),
    'adminMenu': document.querySelector('.adminMenu'),
  };

  // Hide Kardan Tamame Eleman Ham Bejoz Avalin Listener  
    Object.keys(contents).forEach((key, index) => {
    contents[key].style.display = index === 0 ? 'block' : 'none';
  });

  // Add Event Listener Baraye Har Menu Item
  menuItems.forEach(item => {
    item.addEventListener('click', function() {
      const isPersonalInfo = this.querySelector('.fa-user');
      const isQuests = this.querySelector('.fa-person-circle-question');
      const isadminMenu = this.querySelector('.fa-user-shield');
      
      // Hide Kardan Tamame Eleman Ha
      if (isPersonalInfo) {
        contents['personal-info'].style.display = 'block';
        contents['quests'].style.display = 'none';
        contents['adminMenu'].style.display = 'none';
      } else if (isQuests) {
        contents['personal-info'].style.display = 'none';
        contents['adminMenu'].style.display = 'none';
        contents['quests'].style.display = 'block';
      } else if (isadminMenu) {
        contents['personal-info'].style.display = 'none';
        contents['adminMenu'].style.display = 'block';
        contents['quests'].style.display = 'none';
      }

      // Active Kardan Menu Item
      menuItems.forEach(i => i.classList.remove('active'));
      this.classList.add('active');
    });
  });

  // Load Kardan Data Az Lua
  window.addEventListener('message', function(event) {
  const data = event.data;
  const container = document.querySelector('.container');

  if (!container) return;

  switch (data.type) {
    case 'openMenu':
      container.style.display = 'flex';

      // Set default tab to 'personal-info'
      document.querySelector('.main-content').style.display = 'block';
      document.querySelector('.quests').style.display = 'none';
      document.querySelector('.adminMenu').style.display = 'none';

      // Reset active menu item
      document.querySelectorAll('.menu-item').forEach(item => {
        item.classList.remove('active');
        const isPersonal = item.querySelector('.fa-user');
        if (isPersonal) {
          item.classList.add('active');
        }
      });

      break;

    case 'closeMenu':
      container.style.display = 'none';
      break;
  }
});


  // Event Listener Baraye Escape Ya Backspace
  document.addEventListener('keydown', (event) => {
    const container = document.querySelector('.container');

    if (!container) return;

    if (event.key === 'Escape' || event.key === 'Backspace') {
      container.style.display = 'none';

      // Send Kardan Be Lua
      const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'unknown_resource';

      fetch(`https://${resourceName}/menuClosed`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          action: 'menuClosed'
        })
      })
    }
  });
});
