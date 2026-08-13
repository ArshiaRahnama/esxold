// Color codes for progress bar
const PROGRESS_COLORS = {
  low: '#2196F3',     // Narenji
  medium: '#ff9800',  // Abi
  high: '#4CAF50',    // Sabz
  default: 'aqua'     // Default color
};

// Taghir Rang Navar Pishraft
function updateProgressColor(progressBar, percentage) {
  if (percentage >= 100) {
    progressBar.style.backgroundColor = PROGRESS_COLORS.high;
  } else if (percentage >= 70) {
    progressBar.style.backgroundColor = PROGRESS_COLORS.medium;
  } else if (percentage >= 30) {
    progressBar.style.backgroundColor = PROGRESS_COLORS.low;
  } else {
    progressBar.style.backgroundColor = PROGRESS_COLORS.default;
  }
}

// Animation Baraye Pishraft
function animateQuestProgress(progressBar, targetPercentage, duration = 1000) {
  if (!progressBar) return;

  const startPercentage = parseInt(progressBar.style.width) || 0;
  const startTime = performance.now();

  const updateFrame = (currentTime) => {
    const elapsed = currentTime - startTime;
    const progress = Math.min(elapsed / duration, 1);
    const currentPercent = Math.round(startPercentage + (targetPercentage - startPercentage) * progress);

    progressBar.style.width = currentPercent + '%';
    updateProgressColor(progressBar, currentPercent);

    if (progress < 1) {
      requestAnimationFrame(updateFrame);
    }
  };

  requestAnimationFrame(updateFrame);
}

document.addEventListener('DOMContentLoaded', () => {
  const questsGrid = document.querySelector('.quests-grid');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'loadQuests' && Array.isArray(data.quests)) {
      // Clear the existing quests
      questsGrid.innerHTML = '';

      data.quests.forEach(quest => {
        const questElement = `
          <div dir="rtl" class="quest-item" id="${quest.id}">
            <div class="quest-header">
              <i class="fa-solid ${quest.icon} quest-icon"></i>
              <h3 class="quest-title">${quest.title}</h3>
            </div>
            <p class="quest-desc">${quest.description}</p>
            <div class="quest-progress">
              <div class="quest-progress-bar"
                   id="${quest.id}-progress"
                   style="width: 0%">
              </div>
            </div>
          </div>
        `;

        questsGrid.insertAdjacentHTML('beforeend', questElement);

        const progressBar = document.getElementById(`${quest.id}-progress`);
        animateQuestProgress(progressBar, quest.progress);
      });
    }
  });
});
