# Slides Format

Slides markup is a closed subset of HTML with inline styles. The service parses every Slide file it saves, from the web editor and from Agents alike, rejects anything outside these rules, and stores one canonical form. Nothing in a Slide runs: there are no scripts, event handlers or external resources. The sections from "Limits" on are generated from the schema the service validates with; each limit names the error it fails with, and [the deck's files](deck-files.md#errors) says how to handle each error. Limits named for a patch apply to one send.

## Structure

- Each Slide is one file, `project/slides/<id>.html`, holding exactly one `<section>` whose `id` is the file's name; `project/deck.json` orders them and names the cover ([the deck's files](deck-files.md)). Nothing else sits in the file: no `<html>`, `<head>`, `<body>`, `<style>`, `<script>`, `<link>` or loose text. Comments are dropped.
- Every `<section>` has an `id` that is unique in the deck and never changes, and a `style` that sets `background`. The outline lives in `project/deck.json` `sections`, so a Slide file leaves `data-section` out.
- Speaker notes are one `<aside>`, the last child of the `<section>`, holding plain text.
- A `<section>` or `<div>` holds block elements and lays them out; only these two take `display`, `gap` and the other layout properties. Text elements (`h1`, `h2`, `h3`, `p`, `li`) hold text and inline marks. Text written directly in a `<section>` or `<div>` is rejected; wrap it in `<p>`.
- Lists have one level of `<li>`. In a table, every row has the same number of cells, `<th>` cells appear only in the first row, and cells hold plain text.
- Close every element with its end tag, including the elements that hold nothing: `<x-shape kind="rect"></x-shape>`, `<x-icon name="check"></x-icon>`, `<x-connector></x-connector>`. Only `img`, `hr` and `br` have no end tag. Shapes inside an `svg` may close themselves, as in `<path d="M0 0L10 10" />`.
- Markup that an HTML parser would have to repair is rejected rather than guessed at: an unclosed `<p>`, a `<div>` inside a `<p>`, a stray end tag, or table content outside a cell. Write a literal `&` as `&amp;` and `<` as `&lt;`.
- Color names such as `white` are rejected; write hex values such as `#ffffff`.

## Placement

- Children of a `<section>` or `<div>` flow in its flex or grid layout. A `<section>` is a column flex container by default.
- `position: absolute` pins an element to its positioning container: the Slide, or the nearest enclosing `div` that has a `position` of its own. Pin it with `left`, `top`, `right`, `bottom`, `width` and `height` in px. As in CSS, the offsets are measured from the container's padding box, inside its border: `left: 0px` on a Slide is the Slide's left edge, and the Slide's padding does not move pinned elements. The offsets require `position: absolute`.
- `position: relative` is only for a `div` that holds pinned children. A pinned child takes no space in its container's flow, so such a container needs its own `height`.
- An `x-connector` with `x1`, `y1`, `x2` and `y2` is pinned in its positioning container by those coordinates and takes no `width` or `height`. Without coordinates it is a flow element sized by `width` and `height`, drawing a straight arrow along its parent's flex direction.
- `data-build-in` only animates pinned elements, and only while presenting.
- Source order is paint order: later elements draw over earlier ones. There is no `z-index`.
- Every element sizes as border-box: `width` and `height` include its padding and border.

## Canonical form

Reads and receipts return the canonical text, which can differ from what was written:

- Attributes follow the order of the element table, and style declarations the order of the property table, written as `property: value` joined by `; `. An attribute with its default value is dropped, and a boolean attribute is written bare.
- Lengths become `<n>px` (a bare number counts as px), colors become lower-case hex or the comma forms of `rgb()` and `hsl()`, `font-family` names get single quotes, and `font-weight` keywords become numbers.
- Each block child sits on its own line, indented by two spaces per level; text and inline marks stay on their element's line, and an inline `svg` is written on one line. Whitespace collapses as the browser would render it.

<!-- generated:start Written by npm run build:skills from shared/slides/schema.ts. A hand edit fails the build; regenerate with npm run build:skills -- --write-format. -->

## Limits

The canvas is 1920 × 1080 px, and a section's default padding is 128px.

Markup that breaks one of these limits, or any rule in this reference, fails with `unsupported_slide_markup`:

| Item | Limit |
| --- | --- |
| Elements per Slide, inline marks included | 200 |
| Text characters per Slide | 20,000 |
| Inline marks per Slide | 100 |
| Table cells per Slide | 4,000 |
| Rows per table | 100 |
| Columns per table | 24 |
| Each inline svg, in its canonical form | 52 KiB |
| Web font families across the Slides | 4 |
| Levels of nested div | 15 |
| Pinned children per positioning container | 24 |
| Tracks per grid template | 24 |
| Speaker notes characters per Slide | 4,000 |
| data-section characters | 200 |
| alt and aria-label characters | 1,000 |
| Link characters | 2,048 |
| Nesting of inline marks, and of groups in an svg | 32 |
| Shapes, groups, gradients and stops in one inline svg | 2,000 |
| Shapes, groups, gradients and stops across a Slide's inline svgs | 10,000 |
| Longest single text run, attribute value, comment or tag, in characters | 131,072 |

Whole Slides beyond these limits fail with `source_limit`:

| Item | Limit |
| --- | --- |
| Slides in one Slides Artifact | 500 |
| Whole markup without images, and the markup in one patch | 5 MiB |
| Elements in the whole Slides, counting sections, inline marks, table rows and cells, and svg shapes | 50,000 |

A patch beyond this limit fails with `invalid_request`:

| Item | Limit |
| --- | --- |
| Changes in one patch | 200 |

Problems an error lists before counting the rest: 20.

## Elements

Attributes are listed in canonical order. Defaults are the styles an element has before its own `style`.

| Element | Holds | Attributes | Defaults | Description |
| --- | --- | --- | --- | --- |
| `section` | block elements | `id` (required), `data-section`, `data-transition`, `hidden`, `style` (required) | `display: flex; flex-direction: column; padding: 128px; font-family: 'Arial', sans-serif; font-size: 32px; line-height: 1.4; color: #111111` | One Slide: a 1920×1080 canvas. style must set background. Its last child may be `<aside>` with speaker notes. |
| `div` | block elements | `id`, `data-group`, `data-fit`, `data-build-in`, `style` |  | Container laid out as flex or grid; at most 15 levels deep |
| `h1` | text and inline marks | `id`, `data-fit`, `data-build-in`, `style` | `font-size: 96px; font-weight: 700; line-height: 1.1` | Title text |
| `h2` | text and inline marks | `id`, `data-fit`, `data-build-in`, `style` | `font-size: 64px; font-weight: 700; line-height: 1.15` | Heading text |
| `h3` | text and inline marks | `id`, `data-fit`, `data-build-in`, `style` | `font-size: 44px; font-weight: 600; line-height: 1.2` | Subheading text |
| `p` | text and inline marks | `id`, `data-fit`, `data-build-in`, `style` |  | Paragraph text |
| `ul` | `li` | `id`, `data-fit`, `data-build-in`, `style` | `padding: 0px 0px 0px 48px; list-style-type: disc` | Bulleted list of li; one level |
| `ol` | `li` | `id`, `data-fit`, `data-build-in`, `style` | `padding: 0px 0px 0px 48px; list-style-type: decimal` | Numbered list of li; one level |
| `li` | text and inline marks | `style` |  | List item |
| `table` | `tr` | `id`, `data-build-in`, `style` |  | Table of tr; the first row may hold th header cells; at most 100 rows × 24 columns, every row the same length |
| `tr` | `th`, `td` | none |  | Table row of th or td |
| `th` | plain text | `style` | `font-weight: 700; text-align: left; padding: 12px 16px` | Header cell (first row only), plain text |
| `td` | plain text | `style` | `text-align: left; padding: 12px 16px` | Cell, plain text |
| `img` | nothing | `id`, `src` (required), `alt` (required), `data-crop`, `data-build-in`, `style` | `object-fit: cover` | Artifact image |
| `svg` | svg shapes | `id`, `data-build-in`, `style` |  | Inline vector drawing shown as an image (at most 52 KiB); needs viewBox and aria-label, or aria-hidden="true" when decorative |
| `hr` | nothing | `id`, `data-build-in`, `style` | `border-top: 2px solid #d0d5dd` | Divider line |
| `x-shape` | nothing | `id`, `kind` (required), `data-build-in`, `style` |  | Shape: background is the fill; color, border-width and border-style draw the outline (line uses only these). Put text on a shape with a p pinned over it. |
| `x-icon` | nothing | `id`, `name` (required), `aria-label`, `data-build-in`, `style` | `width: 48px; height: 48px` | Icon drawn in color |
| `x-connector` | nothing | `id`, `x1`, `y1`, `x2`, `y2`, `head`, `route`, `data-build-in`, `style` | `border-width: 2px; border-style: solid` | Connector line. With x1 y1 x2 y2 it is pinned to its positioned container and takes no width or height; without them it is a straight arrow in the flow, sized by width and height, pointing along the flex direction. |
| `b` | text and inline marks | none |  | Bold |
| `i` | text and inline marks | none |  | Italic |
| `u` | text and inline marks | none |  | Underline |
| `a` | text and inline marks | `href` (required) |  | Link |
| `span` | text and inline marks | `style` |  | Colored text |
| `br` | nothing | none |  | Line break |
| `aside` | plain text | none |  | Speaker notes, plain text up to 4000 characters; only as the last child of section |

Block elements: `div`, `h1`, `h2`, `h3`, `p`, `ul`, `ol`, `table`, `img`, `svg`, `hr`, `x-shape`, `x-icon`, `x-connector`. Inline marks: `b`, `i`, `u`, `a`, `span`, `br`.

## Attributes

An attribute that has its default value is left out of the canonical form; a boolean attribute is written bare.

| Attribute | On | Value | Default | Meaning |
| --- | --- | --- | --- | --- |
| `id` | `section`, `div`, `h1`, `h2`, `h3`, `p`, `ul`, `ol`, `table`, `img`, `svg`, `hr`, `x-shape`, `x-icon`, `x-connector` | [A-Za-z0-9_-]{1,64} |  | Slide id (required, unique in the Slides, never changes) or element id (unique in its Slide) |
| `kind` | `x-shape` | `rect \| rounded \| ellipse \| diamond \| arrow-right \| arrow-left \| arrow-up \| arrow-down \| line` |  | Shape drawn in the element's box |
| `name` | `x-icon` | a name from the icon set |  | Icon from the built-in icon set |
| `src` | `img` | `asset:<id>` |  | An Artifact image uploaded to these Slides |
| `alt` | `img` | text, may be empty for a decorative image |  | What the image shows |
| `href` | `a` | https://… |  | Link target; only https |
| `x1` | `x-connector` | `<n> (-10000px to 10000px)` |  | Start x in the positioned container |
| `y1` | `x-connector` | `<n> (-10000px to 10000px)` |  | Start y in the positioned container |
| `x2` | `x-connector` | `<n> (-10000px to 10000px)` |  | End x in the positioned container |
| `y2` | `x-connector` | `<n> (-10000px to 10000px)` |  | End y in the positioned container |
| `head` | `x-connector` | `end \| start \| both \| none` | `end` | Which ends carry an arrowhead |
| `route` | `x-connector` | `straight \| hv \| vh \| elbow` | `straight` | straight: one segment; hv: horizontal then vertical; vh: vertical then horizontal; elbow: horizontal-vertical-horizontal with the vertical leg at the midpoint x when the horizontal distance is at least the vertical one, otherwise vertical-horizontal-vertical with the horizontal leg at the midpoint y |
| `aria-label` | `x-icon` | text |  | What the icon means; leave it out for a decorative icon |
| `data-section` | `section` | text up to 200 characters, may be empty |  | This Slide starts a section; the value is the section's one-line description |
| `data-transition` | `section` | `fade \| push` |  | Transition when leaving this Slide in a presentation |
| `hidden` | `section` | no value |  | Skipped when presenting and downloading |
| `data-group` | `div` | no value |  | A group the editor selects and moves as one |
| `data-fit` | `div`, `h1`, `h2`, `h3`, `p`, `ul`, `ol` | `shrink \| none \| grow` | `shrink` | Overflowing text: shrink lowers the font size inside its container down to 60% of the size and then clips; none keeps the size and may overflow; grow keeps its column from compressing the box |
| `data-build-in` | `div`, `h1`, `h2`, `h3`, `p`, `ul`, `ol`, `table`, `img`, `svg`, `hr`, `x-shape`, `x-icon`, `x-connector` | `fade \| rise \| pop, optionally followed by an order 1 to 99` |  | Entrance animation of a pinned element, played only when presenting |
| `data-crop` | `img` | `<zoom 1 to 10> <x 0 to 100>% <y 0 to 100>%` |  | Zoom into the image around a focal point |
| `style` | `section`, `div`, `h1`, `h2`, `h3`, `p`, `ul`, `ol`, `li`, `table`, `th`, `td`, `img`, `svg`, `hr`, `x-shape`, `x-icon`, `x-connector`, `span` | property: value; … |  | Inline style with the allowed properties |

## Style properties

Only the inline `style` attribute styles an element, and each element takes only the properties listed for it.

| Elements | Properties |
| --- | --- |
| `section` | `display`, `flex-direction`, `flex-wrap`, `justify-content`, `align-items`, `align-content`, `grid-template-columns`, `grid-template-rows`, `gap`, `padding`, `font-family`, `font-size`, `font-weight`, `font-style`, `line-height`, `letter-spacing`, `text-align`, `text-transform`, `text-decoration`, `font-variant-numeric`, `white-space`, `text-wrap`, `color`, `text-shadow`, `background` |
| `div` | `position`, `left`, `top`, `right`, `bottom`, `width`, `height`, `min-width`, `min-height`, `max-width`, `max-height`, `flex`, `align-self`, `justify-self`, `grid-column`, `grid-row`, `display`, `flex-direction`, `flex-wrap`, `justify-content`, `align-items`, `align-content`, `grid-template-columns`, `grid-template-rows`, `gap`, `padding`, `font-family`, `font-size`, `font-weight`, `font-style`, `line-height`, `letter-spacing`, `text-align`, `text-transform`, `text-decoration`, `font-variant-numeric`, `white-space`, `text-wrap`, `color`, `text-shadow`, `background`, `border`, `border-top`, `border-right`, `border-bottom`, `border-left`, `border-radius`, `box-shadow`, `opacity`, `transform`, `filter`, `backdrop-filter`, `mix-blend-mode`, `overflow` |
| `h1`, `h2`, `h3`, `p` | `position`, `left`, `top`, `right`, `bottom`, `width`, `height`, `min-width`, `min-height`, `max-width`, `max-height`, `flex`, `align-self`, `justify-self`, `grid-column`, `grid-row`, `padding`, `font-family`, `font-size`, `font-weight`, `font-style`, `line-height`, `letter-spacing`, `text-align`, `text-transform`, `text-decoration`, `font-variant-numeric`, `white-space`, `text-wrap`, `color`, `text-shadow`, `background`, `border`, `border-top`, `border-right`, `border-bottom`, `border-left`, `border-radius`, `box-shadow`, `opacity`, `transform`, `filter`, `backdrop-filter`, `mix-blend-mode`, `overflow` |
| `ul`, `ol` | `position`, `left`, `top`, `right`, `bottom`, `width`, `height`, `min-width`, `min-height`, `max-width`, `max-height`, `flex`, `align-self`, `justify-self`, `grid-column`, `grid-row`, `padding`, `font-family`, `font-size`, `font-weight`, `font-style`, `line-height`, `letter-spacing`, `text-align`, `text-transform`, `text-decoration`, `font-variant-numeric`, `white-space`, `text-wrap`, `list-style-type`, `color`, `text-shadow`, `background`, `border`, `border-top`, `border-right`, `border-bottom`, `border-left`, `border-radius`, `box-shadow`, `opacity`, `transform`, `filter`, `backdrop-filter`, `mix-blend-mode`, `overflow` |
| `li` | `font-family`, `font-size`, `font-weight`, `font-style`, `line-height`, `letter-spacing`, `text-align`, `text-transform`, `text-decoration`, `font-variant-numeric`, `white-space`, `text-wrap`, `color`, `text-shadow` |
| `table` | `position`, `left`, `top`, `right`, `bottom`, `width`, `height`, `min-width`, `min-height`, `max-width`, `max-height`, `flex`, `align-self`, `justify-self`, `grid-column`, `grid-row`, `font-family`, `font-size`, `font-weight`, `font-style`, `line-height`, `letter-spacing`, `text-align`, `text-transform`, `text-decoration`, `font-variant-numeric`, `white-space`, `text-wrap`, `color`, `text-shadow`, `background`, `border`, `border-top`, `border-right`, `border-bottom`, `border-left`, `border-radius`, `box-shadow`, `opacity`, `transform`, `filter`, `backdrop-filter`, `mix-blend-mode`, `overflow` |
| `tr`, `b`, `i`, `u`, `a`, `br`, `aside` | none |
| `th`, `td` | `width`, `padding`, `font-family`, `font-size`, `font-weight`, `font-style`, `line-height`, `letter-spacing`, `text-align`, `text-transform`, `text-decoration`, `font-variant-numeric`, `white-space`, `text-wrap`, `color`, `text-shadow`, `background`, `border`, `border-top`, `border-right`, `border-bottom`, `border-left` |
| `img` | `position`, `left`, `top`, `right`, `bottom`, `width`, `height`, `min-width`, `min-height`, `max-width`, `max-height`, `flex`, `align-self`, `justify-self`, `grid-column`, `grid-row`, `border`, `border-radius`, `box-shadow`, `opacity`, `transform`, `filter`, `mix-blend-mode`, `object-fit` |
| `svg` | `position`, `left`, `top`, `right`, `bottom`, `width`, `height`, `min-width`, `min-height`, `max-width`, `max-height`, `flex`, `align-self`, `justify-self`, `grid-column`, `grid-row`, `opacity`, `transform`, `filter`, `mix-blend-mode` |
| `hr` | `position`, `left`, `top`, `right`, `bottom`, `width`, `height`, `min-width`, `min-height`, `max-width`, `max-height`, `flex`, `align-self`, `justify-self`, `grid-column`, `grid-row`, `border-top`, `opacity` |
| `x-shape` | `position`, `left`, `top`, `right`, `bottom`, `width`, `height`, `min-width`, `min-height`, `max-width`, `max-height`, `flex`, `align-self`, `justify-self`, `grid-column`, `grid-row`, `color`, `background`, `border-width`, `border-style`, `opacity`, `transform`, `filter`, `mix-blend-mode` |
| `x-icon` | `position`, `left`, `top`, `right`, `bottom`, `width`, `height`, `min-width`, `min-height`, `max-width`, `max-height`, `flex`, `align-self`, `justify-self`, `grid-column`, `grid-row`, `color`, `opacity`, `transform`, `filter`, `mix-blend-mode` |
| `x-connector` | `width`, `height`, `color`, `border-width`, `border-style` |
| `span` | `color` |

- On `x-shape`, `background` takes color.
- On `x-connector`, `border-width` takes length 1px to 16px.

A `div` without a `position` that sets `transform` other than `none`, `filter` other than `none`, `backdrop-filter` other than `none`, `opacity` other than `1` or `mix-blend-mode` other than `normal` cannot hold pinned elements, directly or through other `div` elements without a `position`: as in CSS, it would place or layer them itself. Give that `div` `position: relative` so it becomes their positioning container.

Property values, in canonical declaration order:

| Property | Value |
| --- | --- |
| `position` | `absolute`, `relative` |
| `left` | length -10000px to 10000px |
| `top` | length -10000px to 10000px |
| `right` | length -10000px to 10000px |
| `bottom` | length -10000px to 10000px |
| `width` | length 0px to 10000px, or `auto` |
| `height` | length 0px to 10000px, or `auto` |
| `min-width` | length 0px to 10000px |
| `min-height` | length 0px to 10000px |
| `max-width` | length 0px to 10000px |
| `max-height` | length 0px to 10000px |
| `flex` | flex |
| `align-self` | `auto`, `flex-start`, `center`, `flex-end`, `stretch` |
| `justify-self` | `start`, `center`, `end`, `stretch` |
| `grid-column` | span |
| `grid-row` | span |
| `display` | `flex`, `grid`, `block` |
| `flex-direction` | `row`, `column` |
| `flex-wrap` | `nowrap`, `wrap` |
| `justify-content` | `flex-start`, `center`, `flex-end`, `space-between`, `space-around`, `space-evenly` |
| `align-items` | `flex-start`, `center`, `flex-end`, `stretch`, `baseline` |
| `align-content` | `flex-start`, `center`, `flex-end`, `space-between`, `space-around`, `stretch` |
| `grid-template-columns` | tracks |
| `grid-template-rows` | tracks |
| `gap` | 1 to 2 lengths, each 0px to 10000px |
| `padding` | 1 to 4 lengths, each 0px to 10000px |
| `font-family` | font-family |
| `font-size` | length 1px to 1000px |
| `font-weight` | font-weight |
| `font-style` | `normal`, `italic` |
| `line-height` | line-height, its px form 0px to 1000px |
| `letter-spacing` | length -100px to 100px, or `normal` |
| `text-align` | `left`, `center`, `right`, `justify` |
| `text-transform` | `none`, `uppercase`, `lowercase`, `capitalize` |
| `text-decoration` | `none`, `underline`, `line-through` |
| `font-variant-numeric` | `normal`, `tabular-nums` |
| `white-space` | `normal`, `nowrap` |
| `text-wrap` | `wrap`, `balance`, `pretty` |
| `list-style-type` | `disc`, `circle`, `square`, `decimal`, `lower-alpha`, `upper-alpha`, `lower-roman`, `upper-roman`, `none` |
| `color` | color |
| `text-shadow` | text-shadow |
| `background` | paint |
| `border` | border |
| `border-top` | border |
| `border-right` | border |
| `border-bottom` | border |
| `border-left` | border |
| `border-width` | length 0px to 16px |
| `border-style` | `solid`, `dashed`, `dotted` |
| `border-radius` | 1 to 4 lengths, each 0px to 10000px |
| `box-shadow` | box-shadow |
| `opacity` | number 0 to 1 |
| `transform` | transform |
| `filter` | filter |
| `backdrop-filter` | filter |
| `mix-blend-mode` | `normal`, `multiply`, `screen`, `overlay`, `darken`, `lighten`, `color-dodge`, `color-burn`, `hard-light`, `soft-light`, `difference`, `exclusion`, `hue`, `saturation`, `color`, `luminosity` |
| `overflow` | `visible`, `hidden` |
| `object-fit` | `cover`, `contain` |

### Value forms

- **keyword**: one of the listed keywords. Canonical form: lower case.
- **length**: `<n>px (a bare number means px)`. Canonical form: <n>px with at most 3 decimals.
- **lengths**: `<n>px, space separated`. Canonical form: <n>px each.
- **number**: `<n>`. Canonical form: at most 3 decimals.
- **color**: `#rgb, #rgba, #rrggbb, #rrggbbaa, rgb(r, g, b), rgba(r, g, b, a), rgb(r g b / a), hsl(h, s%, l%), hsla(h, s%, l%, a), transparent; channels 0 to 255, alpha 0 to 1, hue -3600 to 3600 degrees, s and l 0% to 100%`. Canonical form: #rrggbb or #rrggbbaa in lower case; rgb(r, g, b) or rgba(r, g, b, a); hsl(h, s%, l%) or hsla(h, s%, l%, a); transparent.
- **paint**: `<color> | linear-gradient([<angle>deg | to <top | bottom | left | right>,] <color> [<n>%], <color> [<n>%], …) | radial-gradient([circle | ellipse] [at <x>% <y>%,] <color> [<n>%], …); 2 to 8 color stops, angle -3600deg to 3600deg, stops and positions 0% to 100%`. Canonical form: as written with canonical colors, angles and percentages; % appears only in stops and positions.
- **border**: `none | <width 0px to 100px> solid|dashed|dotted <color>`. Canonical form: none, or width style color.
- **box-shadow**: `none | [inset] <x>px <y>px [<blur>px [<spread>px]] <color>, … (up to 4; offsets and spread -1000px to 1000px, blur 0px to 1000px)`. Canonical form: inset first, then lengths, then color.
- **text-shadow**: `none | <x>px <y>px [<blur>px] <color>, … (up to 4; offsets -1000px to 1000px, blur 0px to 1000px)`. Canonical form: lengths, then color.
- **transform**: `none | rotate(<-3600 to 3600>deg) scale(<-100 to 100>[, <-100 to 100>]) translate(<-10000 to 10000>px[, <-10000 to 10000>px]) (up to 4)`. Canonical form: functions in written order.
- **filter**: `none | blur(<0 to 1000>px) brightness(<0 to 10>) contrast(<0 to 10>) saturate(<0 to 10>) grayscale(<0 to 1>) sepia(<0 to 1>) invert(<0 to 1>) opacity(<0 to 1>) hue-rotate(<-3600 to 3600>deg) drop-shadow(<x>px <y>px [<blur>px] <color>) (up to 6)`. Canonical form: functions in written order.
- **tracks**: `<n>px (0 to 10000) | <n>fr (0 to 1000) | auto | repeat(<count 1 to 24>, <track> …), space separated, up to 24 tracks`. Canonical form: as written with canonical numbers.
- **span**: `span <n> (1 to 24)`. Canonical form: span <n>.
- **flex**: `none | auto | <grow> [<shrink>] [<basis>px | auto]; factors 0 to 1000, basis 0px to 10000px`. Canonical form: as written with canonical numbers.
- **font-family**: `'<allowed family>', …, <generic family last: sans-serif | serif | monospace>`. Canonical form: each family name in single quotes, generic family last.
- **font-weight**: `100-900 in steps of 100 | normal | bold`. Canonical form: the number (normal is 400, bold is 700).
- **line-height**: `<n> (0 to 10, times the font size) | <n>px | normal`. Canonical form: number or <n>px.

## Inline svg

Elements inside an svg: `g`, `defs`, `path`, `rect`, `circle`, `ellipse`, `line`, `polyline`, `polygon`, `linearGradient`, `radialGradient`, `stop`, `clipPath`.

The svg root takes `id`, `data-build-in`, `style` as an element of the Slide, `viewBox`, `preserveAspectRatio`, `aria-label`, `aria-hidden`, and the drawing attributes its shapes inherit: `fill`, `fill-opacity`, `fill-rule`, `stroke`, `stroke-width`, `stroke-opacity`, `stroke-linecap`, `stroke-linejoin`, `stroke-miterlimit`, `stroke-dasharray`, `stroke-dashoffset`. The elements inside take these attributes:

| Attribute | Value |
| --- | --- |
| `id` | id |
| `d` | path |
| `points` | numbers |
| `x` | length |
| `y` | length |
| `width` | length, 0 to 1000000 |
| `height` | length, 0 to 1000000 |
| `rx` | length, 0 to 1000000 |
| `ry` | length, 0 to 1000000 |
| `cx` | length |
| `cy` | length |
| `r` | length, 0 to 1000000 |
| `fx` | length |
| `fy` | length |
| `fr` | length, 0 to 1000000 |
| `x1` | length |
| `y1` | length |
| `x2` | length |
| `y2` | length |
| `offset` | length, 0 to 1000000 |
| `gradientUnits` | `userSpaceOnUse`, `objectBoundingBox` |
| `gradientTransform` | transform |
| `spreadMethod` | `pad`, `reflect`, `repeat` |
| `clipPathUnits` | `userSpaceOnUse`, `objectBoundingBox` |
| `transform` | transform |
| `fill` | paint |
| `fill-opacity` | number, 0 to 1 |
| `fill-rule` | `nonzero`, `evenodd` |
| `stroke` | paint |
| `stroke-width` | number, 0 to 1000000 |
| `stroke-opacity` | number, 0 to 1 |
| `stroke-linecap` | `butt`, `round`, `square` |
| `stroke-linejoin` | `miter`, `round`, `bevel` |
| `stroke-miterlimit` | number, 1 to 1000000 |
| `stroke-dasharray` | numbers, 0 to 1000000 |
| `stroke-dashoffset` | number |
| `stop-color` | color |
| `stop-opacity` | number, 0 to 1 |
| `opacity` | number, 0 to 1 |
| `clip-path` | reference |
| `clip-rule` | `nonzero`, `evenodd` |
| `vector-effect` | `none`, `non-scaling-stroke` |

Every svg number is within -1000000 to 1000000 unless its attribute gives a narrower range. Value forms of svg attributes:

- **number**: a number
- **numbers**: numbers separated by spaces or commas
- **length**: a number, optionally followed by % or px
- **path**: path data: the commands M L H V C S Q T A Z in either case and numbers
- **transform**: `functions matrix(6 numbers), translate(1 or 2 numbers), scale(1 or 2 numbers), rotate(1 or 3 numbers), skewX(1 numbers), skewY(1 numbers)`
- **paint**: `none | currentColor | url(#id) | a color as in style`
- **color**: `currentColor | a color as in style`
- **reference**: `url(#id) naming a gradient or clip path in the same svg`
- **id**: a letter, then up to 63 letters, digits, _ or -
- **keyword**: one of the listed keywords
- **view-box**: min-x min-y width height, with width and height above 0
- **text**: text up to 1000 characters
- **aria-hidden**: true

## Shapes and icons

`x-shape` kinds: `rect`, `rounded`, `ellipse`, `diamond`, `arrow-right`, `arrow-left`, `arrow-up`, `arrow-down`, `line`.

`x-icon` names: `arrow-right`, `arrow-up-right`, `arrow-down-right`, `check`, `x`, `plus`, `minus`, `circle-check`, `triangle-alert`, `info`, `lightbulb`, `target`, `rocket`, `zap`, `star`, `trending-up`, `trending-down`, `chart-line`, `chart-column`, `chart-pie`, `dollar-sign`, `coins`, `wallet`, `landmark`, `briefcase`, `users`, `globe`, `clock`, `calendar`, `shield-check`, `search`, `quote`.

`data-build-in` effects: `fade`, `rise`, `pop`.

## Fonts

`font-family` lists allowed families and ends with one generic family: `sans-serif`, `serif`, `monospace`.

Basic families come from the viewer's system and never load: Arial, Helvetica, Verdana, Tahoma, Trebuchet MS, Georgia, Times New Roman, Courier New.

Web families load from Google Fonts when the Slides use them; one Slides Artifact uses at most 4:

| Family | Kind | Weights | Italic |
| --- | --- | --- | --- |
| Inter | sans-serif | 100–900 | yes |
| Roboto | sans-serif | 100–900 | yes |
| Open Sans | sans-serif | 300–800 | yes |
| Lato | sans-serif | 100, 300, 400, 700, 900 | yes |
| Montserrat | sans-serif | 100–900 | yes |
| Poppins | sans-serif | 100–900 | yes |
| Source Sans 3 | sans-serif | 200–900 | yes |
| IBM Plex Sans | sans-serif | 100–700 | yes |
| DM Sans | sans-serif | 100–900 | yes |
| Manrope | sans-serif | 200–800 | no |
| Work Sans | sans-serif | 100–900 | yes |
| Space Grotesk | sans-serif | 300–700 | no |
| Plus Jakarta Sans | sans-serif | 200–800 | yes |
| Raleway | sans-serif | 100–900 | yes |
| Oswald | sans-serif | 200–700 | no |
| Bebas Neue | sans-serif | 400 | no |
| Noto Sans | sans-serif | 100–900 | yes |
| Noto Sans SC | sans-serif | 100–900 | no |
| Noto Sans TC | sans-serif | 100–900 | no |
| Noto Sans JP | sans-serif | 100–900 | no |
| Noto Sans KR | sans-serif | 100–900 | no |
| Playfair Display | serif | 400–900 | yes |
| Merriweather | serif | 300–900 | yes |
| Lora | serif | 400–700 | yes |
| Source Serif 4 | serif | 200–900 | yes |
| EB Garamond | serif | 400–800 | yes |
| Libre Baskerville | serif | 400–700 | yes |
| DM Serif Display | serif | 400 | yes |
| Fraunces | serif | 100–900 | yes |
| Noto Serif | serif | 100–900 | yes |
| Noto Serif SC | serif | 200–900 | no |
| Noto Serif TC | serif | 200–900 | no |
| Noto Serif JP | serif | 200–900 | no |
| Noto Serif KR | serif | 200–900 | no |
| JetBrains Mono | monospace | 100–800 | yes |
| IBM Plex Mono | monospace | 100–700 | yes |
| Roboto Mono | monospace | 100–700 | yes |
| Source Code Pro | monospace | 200–900 | yes |

## Instead of

Markup that is not available where it was written, and what to write instead; error messages quote the same advice. An entry whose name the tables above allow on some elements says where. The value forms above take precedence over the units listed here, as for `%` in gradient stops.

### Elements

- `strong`: use `<b>`
- `em`: use `<i>`
- `s`: strike-through is not available inline; use text-decoration: line-through on the text element
- `del`, `strike`: use text-decoration: line-through on the text element
- `h4`: use `<h3>`, or `<p>` with font-size
- `h5`, `h6`: use `<p>` with font-size and font-weight
- `blockquote`: use `<p>` with border-left and padding
- `pre`: use `<p>` with a monospace font-family
- `code`: use a monospace font-family on the text element
- `figure`: use a `<div>` holding the `<img>` and a `<p>` caption
- `figcaption`, `label`, `dd`: use `<p>`
- `header`, `footer`, `main`, `article`, `nav`: use `<div>`
- `sup`, `sub`: not available; use a smaller font-size on a separate pinned `<p>`
- `small`: use `<span style="color: …">` or a separate `<p>` with font-size
- `mark`, `font`: use `<span style="color: …">`
- `picture`, `source`: use `<img src="asset:<id>">`
- `video`: video is not available in Slides; use an image
- `audio`: audio is not available in Slides
- `iframe`, `x-embed`: embeds are not available in Slides; use an image and a link
- `embed`, `object`: embeds are not available in Slides
- `canvas`: use an inline `<svg>` or an image
- `script`: Slides never run scripts; remove it
- `noscript`, `template`, `meta`: remove it
- `style`: use inline style attributes
- `link`: use inline style attributes; fonts load automatically from the allowed list
- `html`, `head`, `body`: write only top-level `<section>` elements
- `title`: the title is Artifact metadata; remove it
- `button`: Slides are not interactive; use a styled `<p>` or `<div>`
- `input`, `select`, `textarea`, `form`: Slides are not interactive
- `thead`: write the header cells as th in the first tr
- `tfoot`: write the row as an ordinary tr
- `caption`: use a `<p>` above the table
- `colgroup`, `col`: set width on the cells
- `dl`: use `<ul>` or `<p>`
- `dt`: use `<p>` or `<b>`
- `text`, `tspan`: svg holds no text; pin a `<p>` over the svg
- `foreignObject`: svg cannot hold HTML; place the HTML next to the svg
- `use`: svg references are not available; draw each shape inline
- `image`: svg cannot load images; use `<img src="asset:<id>">`
- `symbol`: draw each shape inline
- `marker`: use x-connector for arrows, or draw the arrowhead as a path
- `pattern`: use a solid or gradient fill
- `mask`: use clipPath or opacity
- `filter`: use the CSS filter property on the svg
- `animate`, `animateTransform`, `animateMotion`, `set`: svg animation is not available; use data-build-in

### Attributes

- `class`: there are no classes; use the style attribute
- `width`: allowed only on shapes inside an svg; elsewhere, use style width in px
- `height`: allowed only on shapes inside an svg; elsewhere, use style height in px
- `srcset`: use one src="asset:<id>"
- `loading`, `decoding`, `tabindex`, `contenteditable`, `draggable`, `role`, `lang`, `dir`, `xmlns`, `xmlns:xlink`: remove it
- `target`, `rel`: remove it; links open in a new tab safely
- `title`: remove it; tooltips are not shown
- `align`: use text-align or flex alignment in style
- `valign`: use align-items in style
- `bgcolor`: use background in style
- `color`: use color in style
- `border`: use border in style
- `data-*`: remove it; the data attributes are data-section, data-transition, data-group, data-fit, data-build-in and data-crop
- `on*`: Slides never run scripts or event handlers; remove it
- `aria-*`: use alt on images and aria-label on svg and icons

### Properties

- `margin`, `margin-*`: use gap on the parent container, or padding
- `z-index`: paint order is source order; move the element later to draw it on top
- `background-color`: use background
- `background-image`: use background with a gradient, or an `<img>` for a picture
- `background-size`: background takes a color or gradient; use an `<img>` with object-fit for a picture
- `background-position`: use an `<img>` with data-crop
- `background-repeat`, `background-clip`: background takes a color or gradient
- `font`: use font-family, font-size, font-weight and line-height
- `padding-*`: use padding with four values: top right bottom left
- `row-gap`, `column-gap`: use gap: <row>px <column>px
- `flex-grow`, `flex-shrink`, `flex-basis`: use flex
- `inset`: use top, right, bottom and left
- `border-color`: use border: <width>px <style> <color>
- `border-width`, `border-style`: allowed only on `x-shape`, `x-connector`; elsewhere, use border: <width>px <style> <color>
- `border-*-width`, `border-*-color`, `border-*-style`: use border-top, border-right, border-bottom or border-left
- `border-*-radius`: use border-radius with four values: top-left top-right bottom-right bottom-left
- `border-collapse`: tables collapse borders already
- `float`, `clear`: use flex or grid
- `transition`: use data-build-in on a pinned element, or data-transition on the section
- `animation`: use data-build-in on a pinned element
- `cursor`, `pointer-events`, `user-select`, `hyphens`: remove it
- `outline`: use border or box-shadow
- `text-decoration-*`: use text-decoration
- `vertical-align`: use align-items on a flex container
- `word-break`, `overflow-wrap`, `word-wrap`: remove it; text wraps by itself
- `text-overflow`, `-webkit-line-clamp`, `line-clamp`: use data-fit
- `aspect-ratio`: set width and height in px
- `object-position`: use data-crop on the image
- `clip-path`: use x-shape or border-radius
- `content`: write the text in the element
- `grid-template-areas`, `grid-area`: use grid-column and grid-row with span
- `grid-column-start`, `grid-column-end`: use grid-column: span <n>
- `grid-row-start`, `grid-row-end`: use grid-row: span <n>
- `grid-auto-flow`: place items in source order
- `order`: change the source order
- `box-sizing`: every element already uses border-box
- `visibility`: remove the element, or use opacity
- `font-variant`: use font-variant-numeric
- `font-stretch`: choose another allowed font family
- `text-indent`: use padding
- `columns`, `column-count`: use display: grid
- `list-style`: use list-style-type
- `-webkit-*`: vendor prefixes are not available; use the standard property

### Values

- `em`, `rem`, `%`, `vw`, `vh`: use px; the canvas is 1920×1080
- `pt`, `cm`, `mm`, `in`: use px
- `var()`: write the value itself
- `calc()`: write the computed px value
- `url()`: use `<img src="asset:<id>">` for a picture
- `!important`: remove !important
- `currentcolor`: write the color itself
- `inherit`: leave the property out to inherit
- `initial`, `unset`: leave the property out

<!-- generated:end -->
