# Diagrams in a doc

A diagram in a doc is a `diagram` block: a fenced code block whose info string is `diagram` and whose body is ONE `<svg>` element - a drawing with no data (a flow, a tree, a map, pillars, a 2x2). The editor, the share view and every export (HTML, PDF, PNG, Word) draw it from that source, and people edit its labels in place: a click on a label with an id opens its words. You write the drawing's source, never a picture: no image, no script, no styling, and never a screenshot or render of it.

Numbers, dates and anything placed on a scale (bar lengths, a funnel's counts, a time line to scale) are data: they go in a `chart` block drawn from rows ([Charts](charts.md)). A diagram places things by meaning, not by value.

## How much it carries

Two readers, and the ask tells you which. Someone who asks HOW a system works, what lives where, who owns what or why a step exists wants each box to carry its explanation: a name and the few lines that answer them, a key when colour carries a kind; a picture of bare names sends that reader back to the prose. Someone who asks for the flow at a glance, the order of steps or where one thing sits wants few words and reads the shape. Both are good drawings: a dozen explained boxes inside their containers is as right for the first reader as five bare boxes for the second. What limits a picture is the reader's glance and the column it sits in (below), not a count: a picture that asks too much of one glance can become two, or keep its upper levels and hand the leaves to a table or to the sentence under it.

## Where it lives

The drawing sits in the doc's text column, prose and tables above and below it, in front of someone scrolling: they take the picture in at a glance, react to its density before reading a word, and read the small words only if the glance pays. That column is about 680 px wide on a laptop, and the drawing is scaled to fill it whatever its viewBox: a 760 frame shows at about 0.9 (an authored 13 lands near 11.5 px), an 1100 frame at about 0.6 (the same 13 lands at 8 px, under what people read), and on a phone the 760 frame shows at about 0.45. Height is free: the page scrolls and nothing is shrunk to fit a height, so a picture that needs room grows DOWN, not wide. What falls outside the viewBox is cut off, never shrunk into view.

## The frame

- `<svg viewBox="0 0 760 H" role="img" aria-label="<title words>" font-size="13">`: H = the drawing's own height plus a margin of about 24, the drawing centred, no empty band; every label inside it, at least 24 clear on the right. No `width` or `height`: readers size it from the viewBox.
- `role="img"` makes a screen reader treat the drawing as ONE image and skip the labels inside; `aria-label` is the name it says (the title's words are enough).
- Title = the first `<text>`: what the picture shows, the finding a reader should leave with ("Only a green build reaches production"), not its topic ("Deployment process"). A highlight that neither the title, a note nor a key explains reads as decoration.

## Labels

- EVERY text element whose words you type carries its OWN id, to the last one - title, names, body lines under a name, notes, edge labels: `<text data-text-id="<slug>" …>words</text>`. A label without an id cannot be edited in place.
- Two lines = two `<tspan data-text-id="…">` inside one `<text>`, one id per line; a `<text>` that holds `<tspan>`s carries no id of its own (refused `text-id`).
- id = a short slug of the label's own words: letters, digits, `_` and `-`, at most 64, each id once per drawing (`checkout`, `retries`, `step-legal`). The same words after a redraw keep the same id.
- Words on a scale (a tick, a date placed by its position) carry no id: people change them by changing the drawing, never by editing the words beside a mark that stays put.
- Write `&` as `&amp;` and `<` as `&lt;` in words; `&#8594;` and other numeric references are fine.

## What a drawing may hold

Elements: `svg` (the frame only), `g`, `defs`, `marker`, `path`, `rect`, `circle`, `ellipse`, `line`, `polyline`, `polygon`, `text`, `tspan` (inside a `text`), `title` and `desc`. Attributes, in their SVG spelling: geometry (`x y x1 y1 x2 y2 cx cy r rx ry width height d points dx dy`), `transform`, `id`, `fill`, `fill-opacity`, `fill-rule`, `stroke`, `stroke-width`, `stroke-opacity`, `stroke-dasharray`, `stroke-dashoffset`, `stroke-linecap`, `stroke-linejoin`, `opacity`, `font-size`, `font-weight`, `font-style`, `text-anchor`, `dominant-baseline`, `letter-spacing`, `marker-start`, `marker-mid`, `marker-end`; on a `marker`, `viewBox refX refY markerWidth markerHeight markerUnits orient`. Everything else is refused: `style`, `class`, `script`, `image`, `use`, `foreignObject`, links, event handlers, gradients, filters, comments.

Colour → tokens only: `fill` and `stroke` take `none` or `var(--<token>)`, never a hex or a named colour.

| token | for |
|---|---|
| `text-primary` | words (every `<text>` sets `fill`) |
| `text-secondary` | quiet words: notes, edge labels, small print |
| `chart-axis` | borders, connectors, arrowheads |
| `chart-grid` | quiet rules |
| `chart-reference-tint` | a tinted band behind a zone or a base |
| `chart-categorical-1` | the accent: `stroke-width="2"` plus the same token as fill at `fill-opacity="0.12"`; words on it stay `text-primary` |
| `chart-categorical-2` … `-8` | more kinds, each a stated meaning |
| `chart-status-good`, `-warning`, `-critical` | a stated status |

## The look

Norms; depart when the picture earns it.

- Colour is read as meaning: a reader asks what each colour stands for. Emphasis works by contrast: one strong box among quiet ones is found at once, five are not. Same kind of box = same fill; box fill `none`.
- Type: 15 / 13 / 11.5, names `font-weight="600"`, nothing under 10.5 (an authored 10 lands under 9 px). Corners `rx="8"`. Borders and connectors `stroke-width` 1 to 1.25. Steps of 8, at least 16 between boxes. Labels `text-anchor="middle"`, y = centre + font-size / 3. Shadows and gradients read as slideware beside a doc's flat type.
- Arrowheads: ONE `<marker id="<slug>-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" fill="var(--chart-axis)"/></marker>` in `<defs>`, and `marker-end="url(#<slug>-arrow)"` on each connector. A coloured line takes its own marker in that colour (a marker does not take the line's colour).
- Connectors run in the gaps between boxes, never across a box or over a label; they start and end ON a box edge; a far target gets an elbow around the boxes between, not a line through them.
- Loose parts: a box, a bar or a note with no tie to the rest reads as an afterthought. What is in the picture is tied to the thing it acts on: by a line, by sitting inside its container, or by sharing its axis.
- Edge labels sit beside their line with a clear gap (above a level run, right of an upright one), never on it; when the gap between two boxes is narrower than the label, the label goes above the row.
- Box width: a drawing does not wrap - YOU break every line, and a line that is too long runs over its border or is cut at the frame's edge. A box = its longest line of words + 24. A 15/600 name runs about 8.5 units a character, a 13/600 name 7.4, a 13 line 7, an 11.5 line 6.2, so a line holds about (width − 24) / units characters (a 226 box: 27 of a 13/600 name, 32 of an 11.5 line). At a 16 line height a box of a name and n body lines is 40 + 16 n tall (the name's baseline 24 down, the first body line's at 40). A container = 32 for its name line, its children 16 in from its sides and 16 above its foot. You write without seeing the render, so count each line against its box before you send; too long → widen the box or break the line, never words on the border.
- Words in the picture: only what the ask or the doc states. No invented numbers, durations, percentages, paths, parts or loops; a detail you do not know is left out.

## Layouts

The geometry that makes each read; a placed item is a claim, so place only what the ask or the doc states, and an unknown position gets its zone, no finer.

- Flow → steps left to right, a decision as a diamond, a loop back as an elbow under the row.
- 2x2 → two named axes, low → high; four named quadrants; items = labelled dots. A stakeholder map is a 2x2: power up, interest right.
- Pillars → roof = the goal; columns, initiatives inside; a base of enablers.
- Driver tree → left to right from the result, the operator (× + −) between siblings. Issue tree → left to right from the question.
- Flywheel → nodes on a ring, one direction, the reinforcing link named.
- Market map → segments = named zones, players = chips inside. Value chain → chevrons left to right, support activities = bands under them.
- Roadmap → phases = equal bands left to right, each with its name, its dates and its one line; gates = named diamonds on a phase edge with their criteria under them. Dates placed to scale are a time line: a `chart` block.
- Before / after → two small flows at the same scale, the change marked with the accent.
- Operating model → layers top down, who decides what named in each.

## One example

A flow: five boxes, one decision, a loop back, one marker, every typed label under its own id.

````
## Release flow

```diagram
<svg viewBox="0 0 760 280" role="img" aria-label="Only a green build reaches production" font-size="13">
  <defs><marker id="flow-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" fill="var(--chart-axis)"/></marker></defs>
  <text data-text-id="title" x="24" y="34" font-size="15" font-weight="600" fill="var(--text-primary)">Only a green build reaches production</text>
  <g fill="none" stroke="var(--chart-axis)" stroke-width="1.25">
    <path d="M180 110H212" marker-end="url(#flow-arrow)"/>
    <path d="M368 110H392" marker-end="url(#flow-arrow)"/>
    <path d="M520 110H556" marker-end="url(#flow-arrow)"/>
    <path d="M456 150V206" marker-end="url(#flow-arrow)"/>
    <path d="M634 134V206" marker-end="url(#flow-arrow)"/>
    <path d="M378 230H102V134" marker-end="url(#flow-arrow)"/>
  </g>
  <g><rect x="24" y="86" width="156" height="48" rx="8" fill="none" stroke="var(--chart-axis)" stroke-width="1.25"/><text data-text-id="commit" x="102" y="114" text-anchor="middle" fill="var(--text-primary)">Commit lands</text></g>
  <g><rect x="212" y="86" width="156" height="48" rx="8" fill="none" stroke="var(--chart-axis)" stroke-width="1.25"/><text data-text-id="build" x="290" y="114" text-anchor="middle" fill="var(--text-primary)">Build and test</text></g>
  <g><polygon points="392,110 456,70 520,110 456,150" fill="none" stroke="var(--chart-axis)" stroke-width="1.25"/><text data-text-id="tests-pass" x="456" y="114" text-anchor="middle" fill="var(--text-primary)">Tests pass?</text></g>
  <g><rect x="556" y="86" width="156" height="48" rx="8" fill="none" stroke="var(--chart-axis)" stroke-width="1.25"/><text data-text-id="staging" x="634" y="114" text-anchor="middle" fill="var(--text-primary)">Deploy to staging</text></g>
  <g><rect x="556" y="206" width="156" height="48" rx="8" fill="var(--chart-categorical-1)" fill-opacity="0.12" stroke="var(--chart-categorical-1)" stroke-width="2"/><text data-text-id="ship" x="634" y="234" text-anchor="middle" font-weight="600" fill="var(--text-primary)">Ship to production</text></g>
  <g><rect x="378" y="206" width="156" height="48" rx="8" fill="none" stroke="var(--chart-axis)" stroke-width="1.25"/><text data-text-id="notify" x="456" y="234" text-anchor="middle" fill="var(--text-primary)">Notify the author</text></g>
  <text data-text-id="yes" x="538" y="102" text-anchor="middle" font-size="11.5" fill="var(--text-secondary)">yes</text>
  <text data-text-id="no" x="466" y="182" font-size="11.5" fill="var(--text-secondary)">no</text>
  <text data-text-id="smoke" x="624" y="182" text-anchor="end" font-size="11.5" fill="var(--text-secondary)">smoke checks pass</text>
  <text data-text-id="fix-and-push" x="240" y="222" text-anchor="middle" font-size="11.5" fill="var(--text-secondary)">fix and push</text>
</svg>
```

A failed test run loops back to the author; only a green build reaches production.
````

The diagram block goes in the section it belongs to, written in the same patch as the section's text: a heading, the drawing, the sentence that reads it.

## Saving and changing a diagram

- A save checks every diagram block before anything is written. A drawing the readers would not draw refuses the whole save with `diagram block <n> cannot be drawn: <line>:<column> <rule>: <reason>` (`2:3 element: <style> is not an element a diagram may draw`; the line counts from the `<svg>` line): fix that place and send the same write again. A refused save changes nothing.
- A saved diagram is drawn; do not render, convert or screenshot it to check it, and do not install anything.
- People edit labels in place, and their words live in the block's source. A later change starts from a fresh read of the block: keep every label's words as you read them (retyped from memory = their edits undone) and every id on its words.
- A change touches only its block: `ArtifactEdit patch` with one `replace` entry targeting the diagram block by its `id` and `hash`, whose `text` is the whole block again (the fence, the `<svg>` and the closing fence). New words on one label change only those words; a new layout redraws the whole `<svg>`, ids kept.
- An existing chart stays a chart, changed as [Charts](charts.md) says; a code block in another drawing language that a person wrote stays as written - never convert it.
