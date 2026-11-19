(() => {
  'use strict';
  const refresh = document.getElementById('refresh');
  if (refresh) refresh.addEventListener('click', () => location.reload());
})();
