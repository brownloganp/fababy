(() => {
  'use strict';

  // Show "Last updated" in the visitor's own time zone, with a relative hint.
  const stamp = document.getElementById('updated');
  if (stamp) {
    const when = new Date(stamp.dateTime);
    if (!Number.isNaN(when.getTime())) {
      const fmt = new Intl.DateTimeFormat(undefined, {
        weekday: 'short', month: 'short', day: 'numeric',
        hour: 'numeric', minute: '2-digit', timeZoneName: 'short',
      });
      const render = () => {
        const mins = Math.max(0, Math.round((Date.now() - when) / 60000));
        let ago = '';
        if (mins < 1) ago = ' (just now)';
        else if (mins < 60) ago = ` (${mins} min ago)`;
        else if (mins < 24 * 60) ago = ` (${Math.floor(mins / 60)} hr ago)`;
        stamp.textContent = fmt.format(when) + ago;
      };
      render();
      setInterval(render, 60000);
    }
  }

  // Earlier updates: same local-time formatting, no "ago".
  document.querySelectorAll('time.stamp').forEach((t) => {
    const when = new Date(t.dateTime);
    if (Number.isNaN(when.getTime())) return;
    t.textContent = new Intl.DateTimeFormat(undefined, {
      month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit',
    }).format(when);
  });

  const refresh = document.getElementById('refresh');
  if (refresh) refresh.addEventListener('click', () => location.reload());
})();
