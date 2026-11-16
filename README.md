# Baby announcement

A tiny static site on Firebase Hosting (part of GCP, free tier, HTTPS included) at https://littlebrownfam.com. Plain HTML, CSS and a little vanilla JS: no framework, no dependencies, no server.

The site goes through four stages. Each stage is a **version** in `versions/`, all sharing one theme (Christmas ornament, snow, gift tags). `public/` is the only folder Firebase uploads, and right now it holds the **teaser**.

| Version | When to publish | What it says |
| --- | --- | --- |
| `teaser` | now (live) | Due date, days-to-go countdown, no name, no photos |
| `labor` | when Lucy starts labor | "Lucy has started labor"; this page will be updated as soon as she's born |
| `born` | after she's born | She's here, Baby, Mom, and Dad are happy and healthy; more details after a few first family meetings; check back. No name, no photos, no date |
| `announcement` | when you're ready to share the details | Her name, birth details and photos (stock-photo placeholders for now) |

```
versions/
  _shared/        theme used by every version: styles.css, favicon, 404, robots.txt, iPhone icon
  teaser/  labor/  born/  announcement/     each has its own index.html (+ app.js, og-image.jpg, images/)
public/           what gets deployed. Replaced by scripts/use-version.sh
assets/og/        sources for the link-preview cards and iPhone icon
scripts/          helper scripts (below)
firebase.json     hosting config: security headers, CSP, cache rules
```

## Preview a version locally (deploys nothing)

```sh
./scripts/serve.sh labor 8781          # http://localhost:8781
./scripts/serve.sh born 8782
./scripts/serve.sh announcement 8783
```

## Switch the live site to a version

```sh
./scripts/use-version.sh labor         # copies it into public/. Does NOT deploy.
# look it over locally (cd public && python3 -m http.server 8765), then:
./scripts/firebase.sh deploy --only hosting --project baby-brown-teaser-2026
```

`use-version.sh` refuses to continue if any version other than `announcement` contains the baby's name.

## Before publishing each version

- **labor**: re-read the wording once. It names Lucy and says labor has started, and makes no promises about timing.
- **born**: contains no date, name or photos on purpose, so it is safe to push as-is.
- **announcement**: replace the placeholders first: name, birth time, weight, length and the stock photos in `versions/announcement/images/` (1600px and 800px wide pairs; the credit line in its footer goes away once the stock photos do). It has no link-preview tags yet; ask for them when you are ready.

## Link previews (Facebook, Slack, iMessage)

Each non-announcement version has Open Graph and Twitter tags plus a 1200x630 card (`og-image.jpg`). To change a card's wording, edit `assets/og/card.html`, then run `./scripts/make-social-images.sh` (macOS, uses Chrome). Platforms cache previews: for Facebook use its Sharing Debugger and click "Scrape Again".

## Firebase CLI

Use `scripts/firebase.sh` instead of a global install. It runs the CLI on Node 20 using the public npm registry, because `~/.npmrc` on this machine points at a work registry with expired credentials.

```sh
./scripts/firebase.sh login            # sign in with the PERSONAL Google account
./scripts/firebase.sh login:list
./scripts/firebase.sh deploy --only hosting --project baby-brown-teaser-2026
```

The Firebase project (`baby-brown-teaser-2026`) has no billing account, so it stays on the free Spark plan (10 GB storage, about 360 MB transfer per day) and cannot incur charges. The custom domain's DNS lives in Squarespace: an A record `199.36.158.100` plus the `hosting-site=...` TXT record; keep both.

Test with the production headers locally (no login needed):

```sh
./scripts/firebase.sh emulators:start --only hosting --project demo-baby-teaser   # http://127.0.0.1:5000
```

After a deploy, Firebase's CDN can serve a stale page for a short while. If a browser shows an old page, a new release (redeploy) clears it.
