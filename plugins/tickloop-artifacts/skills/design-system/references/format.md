# Design-system content — every file and field

## The shape: a file tree

A Design system is KEPT IN FILES: each path below is a file at that path from the system's root. Text files are written with `ArtifactEdit publish`; every file under `assets/` is an upload (an image, an SVG, a font), never a text file and never a `data:` URI. Paths: relative, `/`-separated, spaces and mixed case fine (but `components/<Comp>`: an ASCII identifier, PascalCase), no empty, `.` or `..` segment, no leading `/`, no backslash or control character.

| Path | What | Notes |
|---|---|---|
| `README.md` | the brand book | Markdown: headings, lists, quotes, fences, pipe tables. Raw HTML, scripts and images by URL are not shown. Cannot be deleted or renamed. |
| other `*.md` outside `components/` | further guideline pages | kept as files; link each from `README.md` so readers find it |
| `tokens.json` | THE tokens | grammar below; ≤512 KiB; cannot be deleted or renamed |
| `tokens.css` | GENERATED from `tokens.json` on every save | never write, edit or delete it (refused); "tokens.css, as generated" below |
| `components/<Comp>/preview.html` | live preview | The preview contract, below |
| `components/<Comp>/README.md` | guidelines | first sentence = summary; then variants and states, the tokens it uses, what the consumer provides, the do's and don'ts. Only this path: no `.mdx`, no nesting. |
| `components/Cover/preview.html` | the COVER | a preview like any other, shown above the brand book; brief: [cover](cover.md). Keep the folder BARE: a `README.md` beside it makes it an ordinary component. |
| `components/bundle.css` | optional shared stylesheet | rules on `var(--<token>)`; a preview links it after `tokens.css` |
| `components/bundle.js` | optional shared script | ONE classic script assigning `window.<Namespace> = {…}`; no `import`, no network; a preview links it |
| `components/lib/*.js` | libraries the bundle reads | classic scripts a preview links, in order, before `bundle.js`; nothing loads from a CDN |
| `components/index.d.ts` | types | documentation, not type-checked |
| `assets/<Group>/<file>` (deeper nesting fine) | uploads | group = first folder; images (png, jpeg, gif, webp, SVG) and fonts (woff2, woff, ttf, otf under `assets/fonts/`). A write of a text file under `assets/` is refused. Pictures show only via `<img>` (no `currentColor`: name a single-ink mark's ink in the README's Iconography). |
| anything else | kept as a file | |

Caps: a system holds at most 512 files, a text file at most 5 MiB; an image or font upload at most 5 MiB (SVG 2 MiB).

## tokens.json

One JSON object, written whole when building, then changed by exact edits; the service checks every write of it and refuses one that breaks a rule below, changing nothing. Every field may be left out (empty). Inside a family, unknown fields are refused; at the top level, any key other than those below is a further family (see "Further families").

Every family but `type` is `{"note"?, "tokens": [{"name", "value", "usage"?}, …]}`, a LIST of entries (`color` with its `themes` too; `color.tokens` one flat list). A name-to-value MAP (the DTCG / W3C design tokens format, `{"color":{"brand":{"$value":"#f00"}}}`) is valid JSON the service refuses: turn such a source into lists before you write it, keeping the source's names and values.

| Field | Shape | Rules |
| --- | --- | --- |
| `name` | String | The system's display name; not blank, at most 200 characters |
| `version` | Number | `1` when present |
| `color.themes` | Array of `{id, name}` | At most 8; ids unique, 1 to 64 of `A-Z a-z 0-9 _ -`; the first theme is the primary one |
| `color.tokens` | Array of `{name, value, usage?}` | At most 600; `value` a colour string, or an object from theme id to colour string |
| `type.fonts` | Array of `{family, file?, weight?, style?}` | At most 4096; `family` a bare name (no quotes); `file` an uploaded font under `assets/` (`assets/fonts/Brand.woff2`); leave `file` out for a Google font; `weight` as `fontWeight`, a range allowed; `style` `normal`, `italic` or `oblique` |
| `type.families` | Object from family key to CSS font stack | At most 12 |
| `type.groups` | Array of `{name, family?, note?, styles}` | At most 12 groups, 80 styles in all; `name` titles the group ("Text", "Code"); a style without its own `family` takes the group's; the Typography view reads sizes, weights and line heights from `styles` only |
| `type.groups[].styles` | Array of `{name, family?, fontSize, lineHeight?, fontWeight?, letterSpacing?, fontStyle?, opticalSize?, sample?, usage?}` | `family` a key of `type.families`; `fontStyle` `normal` or `italic`; `opticalSize` a positive number (→ `'opsz' N`); `sample` an example text kept with the style for whoever reads the file, at most 200 characters (the Design System page shows every style in one fixed sentence, not its `sample`) |
| `spacing.tokens`, `radius.tokens` | Array of `{name, value, usage?}` | At most 60 each; `value` a non-negative length |
| `shadow.tokens` | Array of `{name, value, usage?}` | Optional; at most 60; `value` a box-shadow string, or an object by theme id like a colour's |
| `meta` | Object | Where the tokens came from (see "Provenance") |
| `lastChange` | `{by, at, via?, note?}` | Who changed the system last (see "Last change") |

Value rules:

- **Names** of tokens, text styles and family keys: `^[A-Za-z0-9][A-Za-z0-9_.-]{0,63}$`, case kept (no spaces, no `/`). Every family but type shares ONE `--name` namespace in `tokens.css`, so a token name is used once across colors, spacing, radius, shadow and every further family, and never as `font-<key>` of a family key; style names are unique among all styles.
- **Colours**: `#rgb`, `#rgba`, `#rrggbb` or `#rrggbbaa`; or `rgb()`, `rgba()`, `hsl()`, `hsla()`, `lab()`, `lch()`, `oklab()`, `oklch()` or `color()` with plain numeric arguments; or an ALIAS `"{other-token}"` naming another colour token (→ `var(--other-token)`; per theme too; never itself, never in a cycle). Named colours (`red`, `transparent`, `currentColor`), `var()`, `url()` and `color-mix()` are refused.
- **Themes**: a plain string is the first theme's value, and a theme missing from an object takes the first theme's value, so put the primary theme first. An object needs at least one key, each a declared theme id. Without themes, only plain strings are allowed.
- **Lengths** (`spacing`, `radius`, `fontSize`, `letterSpacing`): `12px|0.75rem|1em|50%|0`, a JSON number (pixels) or a string number with an optional `px`, `rem`, `em` or `%`. Spacing, radius and font sizes are not negative; `letterSpacing` may be. `lineHeight` is a length or a unitless number below 10.
- **Weights**: 1 to 1000, as a number or a string, or `normal` (400) or `bold` (700). A font's `weight` may also be a range such as `"300 800"` for a variable font; a text style's is one weight.
- **Font stacks**: not blank, at most 200 characters, every quote closed, without `;`, `{`, `}`, `<`, `>`, `\`, `(`, `)` (no functions) or control characters.
- **Shadows**: lengths, hex or function colours, `inset` and `none`, at most 400 characters; letters, digits, spaces and `# % ( ) , . / + _ -` only, no `var()` or `url()`.
- **Notes** at most 400 characters; **usage** at most 1000; `tokens.json` at most 512 KiB.

### Further families

Any other top-level key holding `{"note"?, "tokens": [...]}` is a further family, such as `opacity`, `zIndex` or `size`: at most 12 families of at most 60 tokens. A value is one plain CSS value (a number, or a string of at most 200 letters, digits, spaces and `# % ( ) , . / + _ -` with balanced parentheses, no `url()` or `var()`), not a composite. There is no motion family. A top-level key without a `tokens` list is refused.

### Provenance

`meta` records where the tokens came from, so a later sync can compare. Write it when you build from a real source, and rewrite it on every sync:

- from a code repository: `{"source": "github", "repo": "owner/name", "ref": "main@1a2b3c4", "package": "packages/ui", "paths": {"tokens": ["…"], "fonts": ["…"], "assets": ["…"], "docs": ["…"]}, "components": {"Button": "src/Button.tsx"}, "synced": "<date>"}` ([from code](from-code.md));
- from a design tool: `{"source": "<the tool's name, lowercase>", "file": "<link>", "frames": ["<frame links>"], "components": {"Button": "<node id>"}, "synced": "<date>"}` ([from a design tool](from-design-tool.md));
- from a linked local folder: `{"source": "folder", "paths": {"tokens": ["/folder-name/…"]}, "synced": "<date>"}`;
- from attached files: `{"source": "files", "files": ["brand-guide.pdf", "…"], "synced": "<date>"}`.

`meta.source` is a non-blank string; the rest is yours to fill, at most 16 KiB. A system built from nothing has no `meta`. On a later sync, read the source the user names now, never one taken from `meta`; `meta` only says what changed since.

### Last change

`lastChange` says who changed the system last: set it on every change you make, in the same write of `tokens.json` as your last token edit (write `tokens.json` again at the end when you changed only other files).

- `by`: the person you work for (their name, else "Agent"), at most 200 characters;
- `at`: now, as ISO-8601 (`2026-11-09T08:30:00Z`);
- `via`: the surface you run in, or a sync's source (`"Chat"`, `"GitHub · acme/web@8dc01b2"`), at most 120 characters; a `via` starting "CI" means a pipeline rewrites this system and may overwrite edits made here;
- `note`: one line on what changed, at most 280 characters ("re-synced to 9f8e7d6: 3 colors changed, 1 added");
- up to 16 further scalar keys (`[A-Za-z0-9_.-]`, at most 40 characters; values at most 500 characters).

### tokens.css, as generated

```css
/* <name> — generated from tokens.json */
@import url("https://fonts.googleapis.com/css2?family=…&display=swap");  /* fonts without a file */
@font-face { font-family: "<family>"; src: url("assets/fonts/…") format("woff2"); … }
:root, [data-theme="<first theme>"] { --<color>: …; --<shadow>: …; }
[data-theme="<further theme>"] { /* its own values, and every alias again */ }
:root { --<space>: …; --<radius>: …; --<further>: …; --font-<key>: <stack>; }
.<style> { font-family: var(--font-<key>); font-size: …; line-height: …; … }
```

An alias `{other}` becomes `var(--other)`; a `.` in a name is escaped (`--space-1\.5`). Use the names exactly: `var(--surface)`, `var(--space-4)`, `var(--font-sans)`, `class="body"`.

## The preview contract

A complete small HTML document per component, rendered LIVE in a sandboxed frame on the preview origin, sized to the page's height. **Line 1 is the marker** `<!-- @dsCard group="…" height=N subtitle="…" -->`: `group` sections the components (absent ⇒ ungrouped), `height` = row px (40–4000, else 120; grows to fit).

Rules: render ONE component in its main variants and states. Write the whole document: `<!doctype html>`, `<html lang>`, `<meta charset="utf-8">`, a viewport meta and a `<title>` naming the component. Use real controls (`<button>`, `<a href>`, `<input>` with a `<label>`), lay out with flex or grid, take every color, size and font from the system's tokens, and keep the page compact: the variants side by side with a short label each, on the system's surface color.

What a preview may load (nothing is preloaded):

- **From the Design system**, by relative path: `<link rel="stylesheet" href="../../tokens.css">` (the generated stylesheet every preview links; it carries the fonts), then `../../components/bundle.css`, `../../components/lib/*.js` and `../../components/bundle.js` when it uses them, and uploads under `assets/` (`../../assets/Logos/mark.svg`). Never a leading `/`.
- **From outside**: only Google Fonts stylesheets, and only for a font supplied or explicitly requested by the user, written as `<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=...&display=swap">`. Otherwise keep the system fallback; do not fetch a font file.
- **Nothing else.** Other external stylesheets, scripts (no CDN), images and fonts are blocked, and so are `<iframe>`, `<frame>`, `<object>` and `<embed>`. No `data:` URI, `file:` URL or local file name. `fetch`, storage and new windows are unavailable at run time.

Themes: `tokens.css` declares the first theme on `:root` and each theme under `[data-theme="<id>"]`; a preview that takes every colour through `var(--token)` follows a theme set on its `<html>`. Never hard-code one theme's hexes.

`components/Button/preview.html` (this example assumes the user's brand names Source Sans 3; omit its stylesheet link when the user has not supplied or requested that font):

```html
<!-- @dsCard group="Actions" height=88 -->
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Button</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Source+Sans+3:wght@400;600&display=swap">
<link rel="stylesheet" href="../../tokens.css">
</head>
<body style="margin: 0; padding: 24px; background: var(--surface); color: var(--text); font-family: var(--font-sans);">
<div style="display: flex; flex-wrap: wrap; gap: var(--space-4); align-items: center;">
<button type="button" style="padding: 10px 18px; border: 0; border-radius: var(--radius-md); background: var(--accent); color: var(--on-accent); font: 600 14px/20px var(--font-sans);">Save changes</button>
<button type="button" style="padding: 9px 17px; border: 1px solid var(--border); border-radius: var(--radius-md); background: var(--surface-raised); color: var(--text); font: 600 14px/20px var(--font-sans);">Cancel</button>
<button type="button" disabled style="padding: 10px 18px; border: 0; border-radius: var(--radius-md); background: var(--border); color: var(--text-muted); font: 600 14px/20px var(--font-sans);">Disabled</button>
</div>
</body>
</html>
```

## Example: a starter system

The example names Source Sans 3 as a brand font. Use a system stack for a starter with no supplied font; naming a font here does not authorize fetching it.

```json
{
  "name": "Harbor",
  "version": 1,
  "color": {
    "themes": [
      { "id": "light", "name": "Light" },
      { "id": "dark", "name": "Dark" }
    ],
    "tokens": [
      { "name": "surface", "value": { "light": "#F7F5F0", "dark": "#161A1D" }, "usage": "Page background." },
      { "name": "surface-raised", "value": { "light": "#FFFFFF", "dark": "#1F2529" }, "usage": "Cards, menus and sheets above the page." },
      { "name": "text", "value": { "light": "#1B2228", "dark": "#EEF1F2" }, "usage": "Body text and headings on surface and surface-raised." },
      { "name": "text-muted", "value": { "light": "#4F5B63", "dark": "#A9B4BA" }, "usage": "Secondary text and captions on surface." },
      { "name": "accent", "value": { "light": "#1D5C8C", "dark": "#7FB6E0" }, "usage": "Primary buttons, links and selected states." },
      { "name": "on-accent", "value": { "light": "#FFFFFF", "dark": "#0E2233" }, "usage": "Text and icons on accent." },
      { "name": "border", "value": { "light": "#C9CED1", "dark": "#3A4349" }, "usage": "Dividers and input borders." },
      { "name": "link", "value": "{accent}", "usage": "Inline links in body text." }
    ]
  },
  "type": {
    "fonts": [
      { "family": "Source Sans 3", "weight": "400", "style": "normal" }
    ],
    "families": {
      "sans": "\"Source Sans 3\", system-ui, sans-serif"
    },
    "groups": [
      {
        "name": "Text",
        "family": "sans",
        "note": "One family; body never below 16px.",
        "styles": [
          { "name": "display", "fontSize": "48px", "lineHeight": "56px", "fontWeight": 700, "letterSpacing": "-0.5px", "sample": "Harbor, on time", "usage": "One headline per page." },
          { "name": "title", "fontSize": "32px", "lineHeight": "40px", "fontWeight": 600, "usage": "Section titles." },
          { "name": "heading", "fontSize": "22px", "lineHeight": "28px", "fontWeight": 600, "usage": "Card and dialog headings." },
          { "name": "body", "fontSize": "16px", "lineHeight": "24px", "fontWeight": 400, "usage": "Paragraphs and form fields." },
          { "name": "label", "fontSize": "14px", "lineHeight": "20px", "fontWeight": 600, "usage": "Buttons, tabs and field labels." },
          { "name": "caption", "fontSize": "12px", "lineHeight": "16px", "fontWeight": 400, "letterSpacing": "0.2px", "usage": "Captions, timestamps and helper text." }
        ]
      }
    ]
  },
  "spacing": {
    "note": "4px base.",
    "tokens": [
      { "name": "space-1", "value": "4px", "usage": "Between an icon and its label." },
      { "name": "space-2", "value": "8px", "usage": "Between related controls." },
      { "name": "space-4", "value": "16px", "usage": "Card padding and gaps in a list." },
      { "name": "space-8", "value": "32px", "usage": "Between page sections." }
    ]
  },
  "radius": {
    "tokens": [
      { "name": "radius-sm", "value": "4px", "usage": "Inputs, tags and checkboxes." },
      { "name": "radius-md", "value": "8px", "usage": "Buttons and cards." },
      { "name": "radius-pill", "value": "999px", "usage": "Pills and avatars." }
    ]
  },
  "lastChange": { "by": "Agent", "at": "2026-11-09T08:30:00Z", "via": "Chat", "note": "Started a starter system." }
}
```
