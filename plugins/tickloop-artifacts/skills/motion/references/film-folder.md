# The film folder and its scripts

What a film's documents mirror: the store holds the same parts as a folder would. Write the store documents (SKILL.md), never files.

## The film folder you write

```
film/
  film.json        {"title": "Harbor — notes that stay put"}  (what people see; never "Video")
  cut.js           sets window.CUT (below) — the whole timeline
  SOURCES.md       where the material came from, what you approximated; not uploaded
  modules/         CSS/HTML and data: name.css | .html | .js | .json | .txt
    app.css        the recreated UI's pruned CSS (recreate-ui.md)
    composer.html  static markup fragment
    copy.json
  assets/          images, fonts, clips: png jpg webp gif svg · woff2 woff ttf otf · mp4 webm
    board-a.webp
    BrandSans-700.woff2
```

Names match `[A-Za-z0-9][A-Za-z0-9_.-]{0,63}` and keep their extension:
`kit.module('app.css')`, `kit.assets.url('board-a.webp')`.
In the store the folder is `film/meta`, one
`assets/<file>` per image or font (an upload), one `modules/<file>`
per module, `film/script` last. Budgets the store enforces: `cut.js` ≤200 KiB; each
module ≤200 KiB — split a bigger one into `big.css~1`, `big.css~2`…
and `kit.module('big.css')` returns them joined; all modules ≤2 MiB,
≤48 of them; ≤96 assets, rasters small (a 1440-wide webp screenshot is
60–120 KB; prefer lifted DOM anyway); an SVG goes in as markup in an html module or a
`data:` ref (never uploaded). **Fonts are assets**:
each woff2/woff/ttf/otf (uploaded as `font/woff2` etc.) is registered as
a face named by its file stem
(`assets/BrandSans-700.woff2` → `font-family: "BrandSans-700"`). Text in
a family named in CSS that is no asset renders
in whatever the machine has: bring the user's brand
face as files. In a film of scenes with no `look.json` a Google family is named in `scenes.json`'s `fonts` (rough-cut.md) and fetched
by the player; a film in the store with no `scenes.json` takes their files alone; until then the system stacks
stand: make the film, and ask as the one sentence more.

## `window.CUT`

```js
window.CUT = {
  width: 1920, height: 1080,    // integers ≤4096; vertical 1080×1920, 4:5 1080×1350, square 1080×1080
  fps: 60,                      // 24 | 30 | 60; animations want 60
  duration: 32.4,               // seconds, ≤300
  background: '#f4f2ee',        // stage ground (default white); use the user's palette
  chapters: [{ t: 0, label: 'Title' }, { t: 2.6, label: 'The app' }, { t: 9.8, label: 'Make a note' }],
  async init(kit) { /* build the stage once: CSS (kit.css(kit.module('app.css'))), lifted HTML, layers, typists, plates, clips */ },
  render(t, kit)  { /* SYNCHRONOUS: put the stage (and kit.fx) into its state at time t. Nothing else. */ },
  score(S, kit)   { /* optional: music + foley as data — sound.md */ },
};
```

Size, fps, duration and chapters live ONLY here (`film.json` carries the
title). Chapters label the timeline, are seek targets, and are what a
screen reader says for the playhead position — word them for a listener
("Make a note", not "Beat 3") and keep them short; 3–6 chapters is
plenty. Order of events at load: fonts ready → `init(kit)` → `score`
(so `kit.typing.times` is filled if your typists were made in `init`)
→ `render(0)`.

One film has one size; a second aspect ratio is a second film (copy the
folder), recomposed, never cropped or shrunk: stack what sat side by side.
On Reels and TikTok the apps draw over roughly the top 250, bottom 420
and right 120 px (Shorts: bottom 670). Where the person asks for one of those
apps, keep words and logos clear of those areas.

Write the timeline as a cascade of named times so one retime moves
everything after it (the title starts before 0 so frame 0 already shows
it, motion.md §2):

```js
const TT = {}; TT.title = -0.5; TT.app = 2.6; TT.push = TT.app + 0.5; TT.type = TT.push + 1.4;
const PROMPT = 'Lighthouse repairs, before October';
let typed;                                   // in init: typed = kit.typist(PROMPT, TT.type, 24); TT.enter = typed.end + 0.3; …
```

## No scripts here

This Skill ships no scripts: nothing turns a folder into documents, renders stills or checks a film where you work. Write
each document inline with `ArtifactEdit write_db`, as SKILL.md says; a still: [render-offline.md](render-offline.md).
