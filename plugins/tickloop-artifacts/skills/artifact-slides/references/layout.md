# Slide Layout

The canvas is 1920×1080. Every Slide uses `padding: 128px 128px 160px`, so flow content sits in a box 1664px wide and 792px tall, from x 128 to 1792 and from y 128 to 920. The Slide's padding does not move pinned elements: `left: 0px` is the Slide's left edge, so a full-bleed image or the footer band can use the margins. The [format reference](format.md) defines placement, sizing and every property; this reference is about using them well.

## Flow and pinned elements

Flow children move when text grows or a sibling is added, so use flow for content — title stacks, columns, lists, card rows — because it survives later text edits. Use pinning for things whose place is fixed: the footer band, a label over an image, a full-bleed background, decorative shapes, diagram nodes and connectors, and anything with `data-build-in`. Because source order is paint order, put a background image first and the scrim and label after it.

Design so `data-fit` never has to act: authored text fits at its scale size. A pinned box does not grow with its text, so after changing the text of a pinned element, recheck that it still fits; shorten it or split the Slide rather than enlarging the box over its neighbors.

## Flex and grid idioms

A `p` or heading cannot be a flex container, so wrap text that needs alignment in a `div`.

| Layout | Container | Children |
| --- | --- | --- |
| Title with body | `<section>`: `gap: 48px; padding: 128px 128px 160px` | Title, then one body `div` |
| Spaced points | `div`: `display: flex; flex-direction: column; gap: 24px` | One `p` per point |
| Two columns | `div`: `display: grid; grid-template-columns: 1fr 1fr; gap: 64px` | Two `div`s |
| Three columns | `div`: `display: grid; grid-template-columns: repeat(3, 1fr); gap: 64px` | Three `div`s |
| Wide and narrow | `div`: `display: grid; grid-template-columns: 2fr 1fr; gap: 64px` | Main content, then a side note or figure |
| Card grid | `div`: `display: grid; grid-template-columns: repeat(4, 1fr); gap: 48px` | `div`s with padding and background; one spans two tracks with `grid-column: span 2` |
| Centered statement | `<section>`: `justify-content: center` with the standard padding | One large line and an optional source |
| Image beside text | `div`: `display: grid; grid-template-columns: 960px 1fr; gap: 64px; align-items: center` | `img`, then a text `div` |

Nest containers only as deep as the layout needs. Space siblings with `gap` on the parent and pad boxes with `padding`. A `ul` or `ol` has no `gap` and its items take only text styles, so list items sit one line-height apart; use the spaced points idiom when points need room between them. Align the first content element of every content Slide to the same top edge.

A cover, a section opener and a content Slide with the footer band and speaker notes, each its own file. `project/slides/cover.html`:

```html
<section id="cover" style="justify-content: center; gap: 32px; padding: 128px 128px 160px; font-family: 'Inter', sans-serif; color: #f8fafc; background: #0f172a">
  <p style="font-size: 24px; letter-spacing: 2px; text-transform: uppercase; color: #7dd3fc">Board briefing</p>
  <h1 style="font-size: 120px; line-height: 1.05">Expanding into Japan in 2027</h1>
  <p style="font-size: 44px; color: #cbd5e1">A two-market plan with [__] months of runway</p>
</section>
```

`project/slides/costs.html`, which opens the section `{"description": "What the expansion costs and when it pays back", "start": "costs"}` in `project/deck.json`:

```html
<section id="costs" style="justify-content: center; padding: 128px 128px 160px; font-family: 'Inter', sans-serif; color: #ffffff; background: #1d4ed8">
  <h2 style="font-size: 96px">Costs and payback</h2>
</section>
```

`project/slides/payback.html`:

```html
<section id="payback" style="gap: 48px; padding: 128px 128px 160px; font-family: 'Inter', sans-serif; color: #1c1917; background: #faf8f5">
  <h2 style="font-size: 72px; line-height: 1.1">The Tokyo office pays back within [__] months</h2>
  <div style="display: flex; flex-direction: column; gap: 24px; font-size: 34px">
    <p>Setup costs [__], mostly licensing and hiring</p>
    <p>Break-even needs <b>[__]</b> active clients</p>
  </div>
  <div style="position: absolute; left: 128px; right: 128px; bottom: 64px; display: flex; justify-content: space-between; font-size: 24px; color: #57534e">
    <p>Expanding into Japan</p>
    <p>Source: finance plan, [__]</p>
  </div>
  <aside>Lead with the payback period, then name the one assumption it depends on.</aside>
</section>
```

## Vertical space budget

Nothing renders the Slides for you and there is no review pass after saving, so this budget is the layout check: decide each Slide's composition while writing it. Add up every stacked block before saving; the total must stay within 792px. Estimate lines: a Latin sans-serif character averages about half its font size in width, and a CJK character about its full font size. Lines = characters × average width ÷ box width, rounded up. Text wraps only between words, so make every column, card and label at least as wide as its longest word.

| Block | Size and line height | Height |
| --- | --- | --- |
| Eyebrow or kicker line | 24px × 1.2 | about 29px, plus a 16px gap |
| Slide title, one line | 72px × 1.1 | about 80px |
| Slide title, two lines | 72px × 1.1 | about 160px |
| Title to body gap | | 48px |
| Body line | 34px × 1.4 | about 48px |
| Gap between spaced points | | 24px |
| Caption or source line | 24px × 1.3 | about 32px |
| Table row | 2.1 × font size per text line in its tallest cell | about 67px at 32px |
| Card | lines × font size × line height, plus its padding and inner gaps | add them up |

Leave `height` off text boxes and cards so they grow with their content; a fixed height smaller than the content clips it. A one-line title, the gap and five two-line points spaced 24px apart use 80 + 48 + 5 × 96 + 4 × 24 = 704px, which fits. Six such points need 824px, more than the 792px available, so split them across two Slides. When content does not fit, split the Slide; smaller text or `data-fit` is not the fix. Keep a Latin body text block under about 1200px wide so lines stay readable; use the remaining width for a second column or white space.

## Footer band

Pin one `div` with `position: absolute; left: 128px; right: 128px; bottom: 64px; display: flex; justify-content: space-between`, holding a single row of 24px `p` text in the muted color, as in the content Slide above. It sits in the bottom padding, below y 920, so it costs nothing from the content budget. Repeat exactly the same position, styling and kind of content on every content Slide.

## Labels over images

Put the image first, then a scrim, then the label, all pinned. Choose the calmest region of the image for the text; the scrim is a `div` whose gradient background fades from transparent to a dark or light tone under the label. Measure contrast against the scrim's darkest or lightest point under the text, not against the average image. Never rely on text drawn into the image; real text stays searchable, editable and translatable.

A full-bleed image is pinned at `left: 0px; top: 0px; width: 1920px; height: 1080px` with `object-fit: cover`, as the first child of the Slide:

```html
<section id="vision" style="padding: 128px 128px 160px; font-family: 'Inter', sans-serif; color: #ffffff; background: #111827">
  <img src="asset:harbour-dusk" alt="Victoria Harbour at dusk, where the new office opens" style="position: absolute; left: 0px; top: 0px; width: 1920px; height: 1080px; object-fit: cover">
  <div style="position: absolute; left: 0px; top: 480px; width: 1920px; height: 600px; background: linear-gradient(to top, rgba(0, 0, 0, 0.8) 0%, transparent 100%)"></div>
  <h1 style="position: absolute; left: 128px; right: 128px; bottom: 160px; font-size: 120px; line-height: 1.05">One platform for every market we enter</h1>
</section>
```

## Slides edited in the web editor

People edit the same markup in the web editor. Dragging a flow element turns it into a pinned element at the position where it was dropped, and its siblings reflow. Resizing, grouping (`data-group`), cropping (`data-crop`), reordering and fit settings (`data-fit`) are saved the same way.

Treat these as the person's decisions. When revising such a Slide, keep its pinned positions, sizes, groups, crops and source order; change text in place, and do not convert pinned elements back to flow or tidy the layout unless the user asks for a new layout of that Slide. If new text no longer fits a pinned box the person placed, say so and propose a split or a shorter wording instead of moving their element.
