# The earlier format

A Design made before the project layout keeps its files at the top: `canvas.json` and plain HTML boards, with no `project/`. It stays in this format: the service refuses `project/` paths in it, so never move or convert it (to remake one in the new format, make a new Design from it on request). Everything in SKILL.md still applies (the design system step, Craft, Questions, Print's sizes and type, Diagrams' forms, Revising, the View Context, NEVER VERIFY) except what this page replaces: the files, the board format, the order of writes and the install paths. The service checks the rules below on every write; a write that breaks one is refused and changes nothing.

## Files and paths

```text
canvas.json               the index
Main.html                 first board
Cart.html                 board
Landing.html              board
Poster.html               board
Launch-Square.html        board
theme.css                 shared custom properties, linked by every board
assets/logo.svg           uploaded asset
ds/juniper/tokens.json    design system snapshot
ds/juniper/tokens.css     its generated stylesheet
ds/juniper/assets/fonts/Juniper-Sans.woff2   its font, an asset
```

- A path is relative and uses `/` between directories. It has no empty, `.` or `..` segment, no backslash and no control character. A whole path is at most 1,024 bytes and each segment at most 255 bytes.
- A **board** is a top-level file whose name ends in lowercase `.html` and which `canvas.json` lists in `boards`. Name boards with ASCII letters, digits and `-`, starting with a capital letter: `Cart.html`, `Order-Confirmed.html`. An `.html` file the index does not list is an ordinary file.
- `Main.html` is the first board. Every Design has it, keeps it first in `order`, and it cannot be deleted or renamed. `canvas.json` cannot be deleted either. A new Design starts with both: `Main.html` blank (nothing in its `<body>`) as a 1280 × 800 `web` board; rewrite it as your first board, with the kind and size it needs.
- `assets/` holds uploaded images and fonts: `ArtifactUploadAttachment` or `ArtifactUpload` with a new `path` under `assets/`. `publish` can copy an asset to another path within `assets/` with `{"path": "<asset path>"}`; text writes and removals cannot change or remove assets.
- `ds/<namespace>/` holds a design system snapshot, at most 4 of them, written only by its install: SKILL.md's step 4 and [A design system in the Design](design-system-components.md), with `ds/<namespace>/` in place of `project/ds/<folder>/` (`"ds/<namespace>/tokens.json":{"artifact":"<its artifact_id>","path":"tokens.json"}`) and the record in `canvas.json`. Boards link `ds/<namespace>/tokens.css`.
- Every other file is yours to organize: shared stylesheets, scripts, data.

## A complete `canvas.json`

```json
{
  "boards": {
    "Main.html": { "x": 0, "y": 0, "w": 390, "h": 844, "title": "Menu", "page": "app", "kind": "interactive" },
    "Cart.html": { "x": 510, "y": 0, "w": 390, "h": 844, "title": "Cart", "page": "app", "kind": "interactive" },
    "Landing.html": { "x": 0, "y": 0, "w": 1440, "h": 900, "title": "Landing page", "page": "marketing", "kind": "web" },
    "Poster.html": {
      "x": 1560, "y": 0, "w": 794, "h": 1123, "title": "Store poster", "page": "marketing", "kind": "print",
      "paper": { "size": "A4", "orientation": "portrait" }
    },
    "Launch-Square.html": { "x": 2474, "y": 0, "w": 1080, "h": 1080, "title": "Launch post", "page": "marketing", "kind": "fixed" }
  },
  "order": ["Main.html", "Cart.html", "Landing.html", "Poster.html", "Launch-Square.html"],
  "pages": [
    { "id": "app", "name": "App" },
    { "id": "marketing", "name": "Marketing" }
  ],
  "notes": [
    { "id": "order-flow", "page": "app", "kind": "title", "x": 0, "y": -96, "w": 900, "h": 64, "text": "Order flow" },
    { "id": "pickup-time", "page": "app", "kind": "sticky", "x": 1020, "y": 0, "w": 280, "h": 160, "text": "Cart shows the pickup time of the store chosen on Menu." }
  ],
  "launch": { "page": "app", "viewport": { "x": 0, "y": 0, "zoom": 1 } },
  "designSystems": [
    { "title": "Juniper", "namespace": "juniper", "artifact": "0CmRjX7UBoLTi6OVLxQYdF", "version": 42, "copiedAt": "2026-10-31T09:30:00Z" }
  ]
}
```

## `canvas.json` fields

Unknown fields are refused at every level, so an index that exists: keep every key and entry you are not changing, and add no field this table does not name. `notes` and `designSystems` may be left out; every other field is required. Positions and sizes are CSS pixels on the canvas.

| Field | Type | Rule |
| --- | --- | --- |
| `boards` | object | One entry per board, keyed by its path. Must include `Main.html`. |
| `boards[<path>].x` | number | Within ±1,000,000. |
| `boards[<path>].y` | number | Within ±1,000,000. |
| `boards[<path>].w` | number | Above 0 and at most 100,000. |
| `boards[<path>].h` | number | Above 0 and at most 100,000. A `web` board's full content height at `w`. |
| `boards[<path>].title` | string | Not blank, at most 200 characters. Equal to the board's `<title>`. |
| `boards[<path>].page` | string | The `id` of a page in `pages`. |
| `boards[<path>].kind` | string | One of `fixed`, `web`, `interactive`, `print`; see "Board kinds". |
| `boards[<path>].paper` | object | Required when `kind` is `print`; refused for every other kind. |
| `boards[<path>].paper.size` | string | One of `A3`, `A4`, `A5`, `B4`, `B5`, `letter`, `legal`, `ledger`, written exactly so. |
| `boards[<path>].paper.orientation` | string | `portrait` (the default when left out) or `landscape`. |
| `order` | array of strings | Every board path exactly once, `Main.html` first. |
| `pages` | array | At least one page. |
| `pages[i].id` | string | Unique; 1 to 64 characters from `A-Z`, `a-z`, `0-9`, `-`, `_`. |
| `pages[i].name` | string | Not blank, at most 200 characters. |
| `notes` | array | Titles and sticky notes drawn on the canvas. |
| `notes[i].id` | string | Unique among notes; 1 to 64 characters from `A-Z`, `a-z`, `0-9`, `-`, `_`. |
| `notes[i].page` | string | The `id` of a page in `pages`. |
| `notes[i].kind` | string | `title` (a heading over a group of boards) or `sticky` (a remark beside them). |
| `notes[i].x` | number | Within ±1,000,000. |
| `notes[i].y` | number | Within ±1,000,000. |
| `notes[i].w` | number | Above 0 and at most 100,000. |
| `notes[i].h` | number | Above 0 and at most 100,000. |
| `notes[i].text` | string | Plain text, at most 10,000 characters. |
| `launch` | object | The page the canvas opens on. |
| `launch.page` | string | The `id` of a page in `pages`: the one with `Main.html`. |
| `launch.viewport` | object | Required; leave it at `{ "x": 0, "y": 0, "zoom": 1 }`. |
| `launch.viewport.x` | number | Within ±1,000,000. |
| `launch.viewport.y` | number | Within ±1,000,000. |
| `launch.viewport.zoom` | number | Above 0 and at most 64; 1 is actual size. |
| `designSystems` | array | Design systems copied into `ds/`, at most 4, written only by an install. |
| `designSystems[i].title` | string | Not blank, at most 200 characters. |
| `designSystems[i].namespace` | string | Unique; 1 to 64 characters from `a-z`, `0-9`, `_`, `-`, starting with a letter or digit: the directory `ds/<namespace>/`. |
| `designSystems[i].artifact` | string | The 22-character id of the design system's Artifact. |
| `designSystems[i].version` | number, string or null | The system's `revision` as `ArtifactRead list` shows it, or `null`. |
| `designSystems[i].copiedAt` | string | When it was copied, as RFC 3339. |

## Board kinds

| Kind | Use it for | `w` × `h` |
| --- | --- | --- |
| `fixed` | A screen or image of one exact size: a phone screen (390 × 844), a social image, a banner. | The exact size. |
| `web` | A web page whose layout adapts to the window width. | The width it is shown at, such as 1440, and its full content height. It must still work from 360 px wide up. |
| `interactive` | A screen meant to be clicked through: the screens of a prototype. | As for `fixed`. |
| `print` | A piece printed on paper. Needs `paper`. | One sheet at 96 px per inch, below; swap `w` and `h` for `landscape`. |

| `paper.size` | `w` × `h` |
| --- | --- |
| `A3` | 1123 × 1587 |
| `A4` | 794 × 1123 |
| `A5` | 559 × 794 |
| `B4` | 945 × 1334 |
| `B5` | 665 × 945 |
| `letter` | 816 × 1056 |
| `legal` | 816 × 1344 |
| `ledger` | 1056 × 1632 |

A `print` board sets `@page { size: A4 portrait; margin: 0; }` with its own paper and keeps its body a plain block; the canvas and the PDF export lay it out sheet by sheet, its padding the margin of every sheet, and `break-before: page` starts a new sheet. Place it at the right end of its row: its further sheets show to its right.

Lay each page's boards out in a row, in `order`, tops at `y` 0 and 120 px apart; another row 240 px below the tallest board above. Boards on one page never overlap. A `title` note sits 96 px above a row (height 64), `sticky` notes right of the boards they explain.

## A board

Each board is one complete HTML document: `Main.html`, cut down:

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Menu</title>
<link rel="stylesheet" href="theme.css">
<style>
  :focus-visible { outline: 3px solid var(--color-focus); outline-offset: 2px; }
</style>
</head>
<body style="margin: 0; min-height: 100vh; background: var(--color-surface); color: var(--color-text); font-family: var(--font-body);">
  <main style="display: grid; gap: calc(var(--space) * 2); padding: calc(var(--space) * 3);">
    <img src="assets/logo.svg" alt="Juniper Coffee" width="112" height="28">
    <h1 style="margin: 0; font-family: var(--font-display); font-size: 32px; line-height: 1.15;">Order ahead</h1>
    <a href="Cart.html" style="display: inline-flex; align-items: center; justify-content: center; min-height: 44px; padding: 0 calc(var(--space) * 2); border-radius: var(--radius-pill); background: var(--color-accent); color: var(--color-on-accent); font-weight: 600; text-decoration: none;">View cart</a>
  </main>
</body>
</html>
```

Rules that bite (the first three make a board refused or blank): start with `<!doctype html>`, `<html lang>` in the content's language, `<meta charset="utf-8">`, a viewport meta and a `<title>` equal to the board's `title`; close every non-void element and double-quote every attribute. The only external address is a Google Fonts `https://fonts.googleapis.com/css2?...` stylesheet link; no other external stylesheet, script, image or font; no `iframe`, `object` or `embed`; no `data:` URI, `file:` URL or local file name. Files of the Design by relative path, never with a leading `/`; every `<a href>` to another board names a board in `canvas.json`. No network or storage at run time. Each element's look is in its `style` attribute; colors, spacing, radii and fonts are custom properties declared once in `theme.css` (`--color-*`, `--font-*`, `--radius-*`, `--space`), used as `var(--color-text)`, never a literal color; a `<style>` block holds only states, `@media`, `@keyframes`, `@font-face` and tokens. Lay out with flex or grid plus `gap`; `position: absolute` only for what floats above the layout. All UI is in the HTML when it loads: a script toggles `hidden`, attributes or text, never builds the interface (`innerHTML`, `createElement`, a framework). Real `<button>`, `<a href>`, `<input>`, `<select>` and `<textarea>` with `<label>`; every `<img>` has `alt`, `width` and `height`. Motion follows [Motion](motion.md) with plain HTML: CSS in `<style>`, the timeline in a `<script>` that changes existing elements. A diagram follows [Diagrams](diagrams.md)'s forms inside the `<body>`.

## Writing it

- Creating: SKILL.md's steps 1–4 and the plan, then ONE `publish` with one board file and its `canvas.json` entry (the first with the whole `canvas.json`), and only then the next; never two boards in one call. The service refuses an index that names a board whose file is not there, and the canvas shows each board once the index names it. The first is `Main.html`, rewritten from blank, with `theme.css` and the install.
- Add a board: its file plus the `canvas.json` edit adding its `boards` entry and its path in `order`. Rename: the new path as `{"path": "<old path>"}`, the `canvas.json` edit replacing the old key and `order` slot, the boards whose links you updated, and the old path as `null` (`Main.html` cannot be renamed: swap two boards' contents instead). Remove: the `canvas.json` edit taking it out of `boards` and `order` (and notes that only describe it), updated links, and its path as `null`. A call applies texts, then copies, then `canvas.json`, then removals.

| Message | Cause and fix |
| --- | --- |
| `canvas.json: boards["Cart.html"] names Cart.html, which is not a file of the Design` | Publish the board file with the index, or before it. |
| `canvas.json: order is missing "Cart.html"` | Add the board to `order`. |
| `canvas.json: boards["Poster.html"].paper is required for a print board` | Add `"paper": { "size": "A4" }`, or change its kind. |
| `canvas.json: boards["Cart.html"].w must be greater than 0 and at most 100000` | Keep sizes within the table's limits. |
| `Cart.html is a board: remove boards["Cart.html"] and its entry in order from canvas.json before deleting it` | Send the `canvas.json` edit with the removal. |
| `Main.html is the Design's first board; it cannot be deleted or renamed` | Change its content instead. |
| `Invalid file path "assets/logo.png": assets/ holds uploaded assets` | Upload the asset, or draw it inline with `<svg>`. |
