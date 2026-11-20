# Typefaces and the look

Read this when you choose the typefaces and colors for the deck (step 1 of Creating), or when a design system brings its own fonts. With no design system, a new deck takes its type from the brief and subject; where that's neutral, as in a report or sales deck, use Inter for text and Space Grotesk for headings, linked as `family=Space+Grotesk:wght@300..700&family=Inter:wght@400;600`: Space Grotesk stops at 700, and one weight that a family lacks fails the whole link. Space Grotesk has Latin letters only, so for Cyrillic, Greek or other scripts choose a heading face that has them. Slides added to an existing deck keep its typefaces. The deck states its typefaces in `project/deck.json` `faces`, never inside a Slide file.

## Web fonts

**The normal case is a web font: a Google Fonts family, loaded by a `faces` entry. Prefer the families on the [format reference](format.md)'s list.** One entry per family, keyed by the family lowercased with spaces as `-`:

```
"faces": {
  "space-grotesk": {"family": "Space Grotesk", "href": "https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300..700&display=swap"},
  "inter": {"family": "Inter", "href": "https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap"}
}
```

In the link, write `family=` and the font name with spaces replaced by `+`, then `:wght@` and a range or list of the weights the format reference gives that family. Do not use `%` escapes. Keep each link to 1024 characters or fewer. Only links that start with `https://fonts.googleapis.com/css2?` are allowed. A family on the format reference's list works on every deck. Any other Google Fonts family works only once its `faces` entry is saved, so send the index before the Slides that name it.

Each family becomes a typeface you can use in the deck. To use it, write its name in `font-family`:

- `font-family: 'Text Face', sans-serif` on every `<section>`, so its children inherit it; without one, a Slide uses Arial.
- `font-family: 'Heading Face', serif` on headings, when they use another face.
- Put names in quotes, and end with one generic family (`sans-serif`, `serif`, `monospace`). The basic families the format reference lists, such as Arial, Georgia and Courier New, come from the viewer's system, never load and need no `faces` entry.

Use 4 or fewer web font families in a deck. Two is the norm. Linked fonts render in the editor, while presenting, in the share view and in the PDF download; the PPTX download names the same families, which PowerPoint shows only where they are installed; the sandbox look renders offline, where they fall back and are listed under `unavailableFonts`.

For Chinese, Japanese or Korean text, include the matching Noto family from the list — Simplified Chinese (SC), Traditional Chinese (TC), Japanese (JP) or Korean (KR) — after any Latin family, as in `font-family: 'Inter', 'Noto Sans SC', sans-serif`; it counts as a web font family and needs its own `faces` entry. The Noto CJK families have no italic, so do not rely on italics in CJK text.

## A design system's fonts

A design system names its typefaces in `tokens.json` and its README. A family on the format reference's list: link it with `href` as above. A font FILE the system keeps under `assets/` (ending `.woff2`, `.woff`, `.ttf` or `.otf`): install it WITH the system, in the same send as its `tokens.json` ([the deck's files](deck-files.md#a-design-system-in-the-deck): one more `files` entry per font, landing at the same path under `project/ds/<folder>/`), and that landing path is the family's `src`:

```
"faces": {"acme-sans": {"family": "Acme Sans", "src": "project/ds/acme/assets/fonts/AcmeSans.woff2"}}
```

A `family` begins with a letter, then letters, digits, spaces, `_` or `-`, 40 at most. A static font file with only one weight renders every weight at that weight: prefer a variable font file, or the single weight you use the most. A font that is not installed, or whose copy was refused: use the closest family from the format reference's list, and say so in one line.

A font file the user gives you outside a design system cannot be uploaded to Slides (uploads take images only): use the closest family from the list and tell the user. Never write a font as a `data:` URI, and never download a font file.

Symbols that the typeface does not include (✓ ✗ ★ ☐ and most dingbats) fall back to a system font. For a check mark, write `<x-icon name="check"></x-icon>`; for a "no", use a word or a plain −.

## Other typefaces, when the brief calls for them

All of these are on the format reference's list. Link the ones you choose, each with a `:wght@` range covering the weights you use, names exactly as shown here.

**Text (body) typeface — choose ONE. If your deck uses only one typeface, it will be this one.**

- sans: `Inter` (neutral) · `DM Sans` (modern consumer) · `Work Sans` (friendly neutral) · `Manrope` (product) · `IBM Plex Sans` (technical, enterprise) · `Source Sans 3` (civic, quiet)
- geometric: `Poppins` · `Plus Jakarta Sans` (consumer, startups) · `Montserrat` (bold consumer)
- serif: `EB Garamond` (academic, heritage) · `Libre Baskerville` (editorial, reports) · `Source Serif 4` · `Merriweather` (long reading)
- mono: `JetBrains Mono` · `IBM Plex Mono` (developer decks, code)

**Display (heading) typeface — choose ONE from a different row than your text typeface.**

- sans: `Space Grotesk` · `DM Sans` · `Manrope`
- serif: `Playfair Display` · `Fraunces` · `DM Serif Display` (display sizes only) · `EB Garamond` · `Lora`
- condensed: `Oswald` · `Bebas Neue` (posters, sports, statements; capitals only)

## Pairings by mood (headings + text), when a brief asks for one

- Editorial / magazine: `Playfair Display` + `Source Sans 3`, or just `Libre Baskerville` (headings at 700)
- Luxury / hospitality: `DM Serif Display` + `Work Sans`
- Institutional / research / policy: `EB Garamond` + `IBM Plex Sans`, or `Source Serif 4` + `IBM Plex Sans`
- Literary / non-profit / education: `Lora` + `Source Sans 3`, or just `Libre Baskerville`
- Academic / heritage: just `EB Garamond` (headings at 600)
- Product / startup / SaaS: just `DM Sans`, or `Space Grotesk` + `Inter`
- Developer / infrastructure: `IBM Plex Sans` + `JetBrains Mono`, or `Inter` + `IBM Plex Mono`
- Bold / poster / sports: `Oswald` + `Work Sans`, or `Bebas Neue` + `Inter`
- Playful / consumer: `Poppins` + `Plus Jakarta Sans`, or `Fraunces` + `Manrope`
- Quiet / minimal: just `Inter`, or just `Source Sans 3`

Do not choose a typeface only because it is first in a list.

## Rules that keep a deck from looking generic

The checklist in the Slides Skill is the rule set. Here are the numbers behind it:

- **Two faces is the norm; a third only when it has a clear job.** One of them is the display face.
- **Color in hex, chosen once.** Choose one dark color and one light color. You may also choose zero, one, or two accent colors; two accents share the same chroma and lightness but differ in hue. Tone the whites and blacks toward the palette: `#fbfbf8` instead of pure white, `#14213d` instead of pure black. Never use raw `#ffffff` or `#000000` unless you want a stark look on purpose. Use two background tones per deck, plus the one accent statement Slide. Add a `background` style to every section.
- **Contrast is a number** (below). If you use a light accent color (like `#e8c547`), put dark text on it.
- **Color never says it alone.** A status, a good/bad split, the winning bar, a risk level or a highlighted cell also says so in its text ("+4%, over plan"; "High risk"); a dash, a ✓ or an icon standing for a word gets the word beside it.
- **The type scale is the hierarchy.** Use four or five font sizes, for example 120 / 72 / 44 / 32 / 24, and reuse them across the deck. Use the accent color for eyebrows. Use the dark tone for headings on a light background, or the light tone on a dark background. For body text, use a softened dark color (like `#4a5568` on a light background, or `#bfd8d5` on a dark background).
- **Typographic punctuation.** In all the text people read (Slides, speaker notes, the deck's title, section descriptions), type `’` for the apostrophe and the quotation marks of the text's language (`“ ”` in English, `« »` in French, `„ “` in German, `「」` or `“ ”` in Chinese). Keep straight `'` and `"` as HTML, CSS and JSON syntax, in code shown on a Slide, and for feet and inches.

## Contrast

| Element | Minimum contrast against its actual background |
| --- | --- |
| Text below 44px, including footer, captions and chart labels | 4.5:1 |
| Text at 44px and above | 3:1 |
| Essential graphics: bars, lines, connectors, icons, swatches | 3:1 |

Measure text over an image against the scrim or the image area directly under it. Colored backgrounds, such as a section opener in the accent color, need the same check for their text. Decorative rules and fills that carry no meaning are exempt. A chosen design system's own pairs override these ratios.

Two starting palettes, each color measured against its own background:

| Background | Primary text | Muted text | Accent | Second accent |
| --- | --- | --- | --- | --- |
| Light `#faf8f5` | `#1c1917` 16.5:1 | `#57534e` 7.2:1 | `#1d4ed8` 6.3:1 | `#b45309` 4.7:1 |
| Dark `#0f172a` | `#f8fafc` 17.1:1 | `#cbd5e1` 12.0:1 | `#7dd3fc` 10.7:1 | `#fbbf24` 10.7:1 |

White text on the light palette's accent `#1d4ed8` measures 6.7:1, so the accent also works as a filled background. Recheck any color you change against the background it actually sits on.
