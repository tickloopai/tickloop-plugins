# Design suggestions

These cover what the person didn't specify. Most follow from two facts: readers never saw your conversation, and the numbers change while your words stay.

- Under the title, one sentence says what the numbers say now. Fill it from the data, like every word that depends on the numbers (up, down, who leads).
- Give a headline figure its signed change and comparison period. Color the change by whether it's good, not by its sign. A card says its window ("Last 28 days").
- Most pages need no notes, but define a metric in plain words where it first appears. Longer ones that the person asks for, such as definitions, fit a closed `<details>` at the foot, its `<summary>` saying what's inside.
- A caveat that changes how a figure reads stands beside it or in the takeaway. If you left a source out, name it on the page and say why. Show a lift with its interval, and whether that crosses zero. Draw lines point to point, since a curve suggests values the data lacks.
- `<select class="dash-select">` has the dashboard's look. Its arrow is a background image in the right padding, so style it with `background-color`, not `background` or `padding`.
- Each chart's code measures its margins from the widest tick and end label as drawn (`getComputedTextLength()`, which is 0 until the chart is in the page) and keeps labels from meeting (fewer ticks, end labels moved apart), since the data sets a label's width and place.
- A table wider than the pane can scroll sideways in a wrapper with `overflow-x: auto`, or the whole page slides.
- A screen reader gets nothing from a drawn chart, so its `svg` has `role="img"` and an `aria-label` that says what it shows.
- Numbers and dates are formatted. A date-only string parses as UTC midnight. Without `d3.utcFormat`, a reader west of UTC sees the day before.

Shapes to mix or ignore. Where one contradicts a suggestion above, the shape wins:

- **Visual analysis** — one finding, read top to bottom: a sentence around one number, then charts, each under a heading that says what it shows.
- **Scroll story** — also scrollyteller, story or narrative: a finding told as the reader scrolls. Short chapters stand beside one chart that stays in view and changes with them. An `IntersectionObserver` needs `root: document` here, or its `rootMargin` is ignored.
- **Letter** — an update written to its readers: each number inside its sentence, `[brackets]` for what only the person can say, and no tiles, headline figure or filters.

If the View Context has a `form` other than `dashboard`, the person picked that shape from pictures. Build only that shape, not a mix. `visual-analysis` means Visual analysis and `scroll-story` means Scroll story. Their message can still ask for another shape, but the word "dashboard" doesn't. `dashboard` is only the default, so a message asking for another shape, such as a story or deep dive, gets that shape.

### Look

The dashboard sets plain text defaults and an outer gutter, so don't pad your outer wrapper. `#dash-root { --dash-gutter: 0 }` runs it edge to edge. The page also appears in a narrow pane beside a chat, and narrows when Sources opens. A fixed-width `<svg>` keeps it from narrowing, but `width="100%"` with a `viewBox` is fine. `position: fixed` scrolls with the page, so make a tooltip `absolute` inside a `relative` box.

Only these tokens are guaranteed; a name you guess can silently resolve to nothing. Use them rather than typed colors, so the page keeps the dashboard's look.

- Color: `var(--color-fg)`, `--color-fg-muted`, `--color-bg`, `--color-panel`, `--color-border-line`, `--color-ok`, `--color-warn`, `--color-bad`.
- Text: `var(--font-anthropic-sans)`, and `--font-anthropic-serif` at weight 400 for big numbers and the page title. Sizes are `--cds-font-size-` plus `caption`, `body`, `heading` or `title`, with `--cds-font-weight-medium`. `font-variant-numeric: tabular-nums` keeps numbers lined up.
- Space: `--cds-gap-` and `--cds-pad-` plus `xs`, `sm`, `md`, `lg` or `xl`, with `--cds-radius` for corners.
- Cards: `--color-panel` with a 1px `--color-border-line` border, `--cds-radius` and `--cds-pad-lg`.
- Charts: bars, lines and dots take `dash.colors` in order, `dash.colors[0]` where there is one series. They are `var(--…)` strings, which `d3.color()` can't parse, so set them as styles. `--cds-chart-muted` is for context, `--cds-chart-status-critical` for a value past its limit, and `--cds-chart-grid`, `--cds-chart-axis` and `--cds-chart-reference` for the lines behind a chart. The grid and axis colors are too faint for words, so tick labels are `--cds-text-secondary` at caption size: CSS on an axis's `text` sets that over the size and font that d3.axis puts on its group.
- Tooltips: `--cds-surface-popover`, `--cds-border`, `--cds-shadow-popover`, `--cds-text-secondary`.
- Put motion inside `@media (prefers-reduced-motion: no-preference)`, or the same `matchMedia` test in a script, so people who turned motion off get none. Use `--cds-dur-slow` and `--cds-ease-out`. Drawing code reruns on every data or width change, so play entry motion once, on the first draw with rows.

### States

The dashboard shows readers load errors, so a source's message stays off the page. For your CSS, it sets `data-dash-source-state="loading|refreshing|error"` on marks and `data-dash-state="loading|error"` on `#dash-root`. While a source re-runs, its marks keep their last values, so fade the `refreshing` ones: `[data-dash-source-state=refreshing] { opacity: .5; }`. A page full of `—` reads as broken while it loads. The class `dash-skeleton` draws a placeholder over an element and hides its contents. It fills a box with nothing in it, not even a space, and one that holds only text, a `—` too, gets a short bar. Only your script removes it, when data arrives or the load fails: once the status isn't `"loading"`, or it stays for good.

A chart's box with no `min-height` is at most a line tall until its data arrives, so the page jumps as each one does. Where the status is `"error"`, a quiet "Failed to load" drawn in the chart's place tells the reader which chart failed.

### Handing over

This part isn't a suggestion, since the person learns it only from you. Tell them, in a line each, what they can do next: ask you for any chart or control by name, such as a flow diagram, a date filter or a click that filters the whole page; and open Sources to see where any number comes from. If you attached a file, also: download its rows there; and, as an editor, edit or replace it there, test it on the page and save it. If a source is live, also: its numbers update each time the page opens, or with the refresh button above it; each reader runs it with their own access and is asked once to allow the connector; and an editor can let readers use their access instead, in Sources. Then what to know about their data: everyone who can open the dashboard can read its attached files, whatever their own access, and a file's numbers change only when someone attaches a newer one.

If you couldn't attach a file, because you had no way to write or reach one, promise none of that, since Sources then has no file to download or edit. Say instead that the numbers are written into the page, so changing them means asking you, and that a Chat started from Work, or a connected app, can attach them as a file that they can then edit in Sources.

Rows you wrote yourself, whether sample, estimated or recalled, go in a file whose `title` starts with "Sample" and whose `description` says how you made them. Say which numbers those are, because the person may pass them on as real.

### Links

On a page with tabs or sections, `dash.setLink("usage")` as the reader moves to `#usage` names that place in what the dashboard tells you of their view (`place` in [features](features.md)).
