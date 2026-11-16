(() => {
  'use strict';

  const due = document.getElementById('due');
  const sentence = document.getElementById('countdown');
  const days = document.getElementById('days');
  if (!due || !sentence || !days) return;

  // "2026-12-17" must be parsed as a local calendar date, not UTC.
  const [y, m, d] = due.dateTime.split('-').map(Number);
  const dueDay = new Date(y, m - 1, d);
  if (Number.isNaN(dueDay.getTime())) return;

  const now = new Date();
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const left = Math.round((dueDay - today) / 86_400_000);

  if (left > 1) {
    sentence.textContent = `${left} days to go`;
    days.textContent = String(left);
  } else if (left === 1) {
    sentence.textContent = 'Just 1 day to go';
    days.textContent = '1';
  } else if (left === 0) {
    sentence.textContent = 'Due today. Any moment now!';
    days.textContent = 'Today';
  } else {
    sentence.textContent = 'Any moment now!';
    days.textContent = 'Any day';
  }
})();
