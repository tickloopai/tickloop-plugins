# Diagrams and Charts on a Slide

A Slide diagram or chart makes one point that the title states. Show the main path or the key comparison; move secondary branches, full data and caveats to the next Slide, the notes or an appendix Slide marked `hidden`. Keep a diagram to about seven nodes and a chart to about eight bars or four lines. The [format reference](format.md) lists the `x-shape` kinds, the `x-icon` names and the full attribute rules.

## Pick the form

| Point to make | Form |
| --- | --- |
| A short linear process | A flex row of boxes with flow connectors between them |
| Structure, dependencies or a branching flow | Pinned boxes joined by coordinate connectors |
| Change over time | A line drawn in inline `svg`, with labels as Slide text |
| Comparing categories | Bars built from `div`s on one baseline |
| One number that matters | A statement Slide with the number large and its definition and source below |
| Exact values to look up | A table of at most about eight rows |

Prefer HTML elements over inline `svg` wherever they can draw the form. The web editor shows `svg` as an image, so people cannot edit what is inside it; boxes, text and connectors stay editable.

## A linear process

For steps that sit in one line, place a flow `x-connector`, one without coordinates, between each pair of boxes in a flex row or column. It needs no geometry and keeps working when a person edits the text, so prefer it whenever the steps sit in one line.

```html
<section id="account-steps" style="gap: 96px; padding: 128px 128px 160px; font-family: 'Inter', sans-serif; color: #111827; background: #ffffff">
  <h2 style="font-size: 72px; line-height: 1.1">Opening an account takes four steps</h2>
  <div style="display: flex; align-items: center; gap: 24px">
    <div style="width: 320px; height: 160px; display: flex; align-items: center; justify-content: center; padding: 24px; background: #eff6ff; border: 2px solid #1d4ed8; border-radius: 16px">
      <p style="font-size: 32px; text-align: center">Sign up</p>
    </div>
    <x-connector style="width: 72px; height: 32px; color: #1d4ed8"></x-connector>
    <div style="width: 320px; height: 160px; display: flex; align-items: center; justify-content: center; padding: 24px; background: #eff6ff; border: 2px solid #1d4ed8; border-radius: 16px">
      <p style="font-size: 32px; text-align: center">Verify identity</p>
    </div>
    <x-connector style="width: 72px; height: 32px; color: #1d4ed8"></x-connector>
    <div style="width: 320px; height: 160px; display: flex; align-items: center; justify-content: center; padding: 24px; background: #eff6ff; border: 2px solid #1d4ed8; border-radius: 16px">
      <p style="font-size: 32px; text-align: center">Risk assessment</p>
    </div>
    <x-connector style="width: 72px; height: 32px; color: #1d4ed8"></x-connector>
    <div style="width: 320px; height: 160px; display: flex; align-items: center; justify-content: center; padding: 24px; background: #1d4ed8; border-radius: 16px">
      <p style="font-size: 32px; text-align: center; color: #ffffff">Deposit funds</p>
    </div>
  </div>
</section>
```

## Boxes first, then connectors

For structure and branching, pin the nodes and join them with coordinate connectors.

1. Put the whole diagram in one `div` with `position: relative` and an explicit `height` under the title. Nodes and connectors then share its coordinates and the diagram moves as one unit. The pinned-children limit counts its nodes, connectors and labels together.
2. Lay out a grid in that container and give every node explicit `left`, `top`, `width` and `height` on it. Peers share one size; align their centers on a row or column.
3. Make each node a pinned `div` with background, border or radius, holding its text as `p` or `h3`; `display: flex; align-items: center; justify-content: center` centers it. Size it for the real label in the output language: two lines at 28–32px at most. `x-shape`, `x-icon` and `x-connector` hold no content, so a non-rectangular node, such as a decision diamond, is an `x-shape` with a `p` pinned over it in the same box.
4. Only then add the connectors, after the boxes in source order so the arrowheads paint on top.

## Connector endpoints and routing

Start and end each coordinate connector on the midpoint of a box edge, computed from the box geometry:

| Edge | Point |
| --- | --- |
| Right | `left + width`, `top + height / 2` |
| Left | `left`, `top + height / 2` |
| Top | `left + width / 2`, `top` |
| Bottom | `left + width / 2`, `top + height` |

Pick the edges and the `route` together, so the line leaves and enters each box at a right angle:

| `route` | Path | Edges to use |
| --- | --- | --- |
| `straight` (default) | One segment | Facing edges whose midpoints share an x or a y exactly |
| `hv` | Horizontal, then vertical | Start on a left or right edge, end on a top or bottom edge |
| `vh` | Vertical, then horizontal | Start on a top or bottom edge, end on a left or right edge |
| `elbow`, horizontal distance at least the vertical one | Horizontal–vertical–horizontal, the vertical leg at the midpoint x | A right edge to a facing left edge |
| `elbow`, otherwise | Vertical–horizontal–vertical, the horizontal leg at the midpoint y | A bottom edge to a facing top edge |

- Point every arrowhead (`head`) the way the flow runs.
- Give a dashed or dotted line one stated meaning, such as "planned", and name it in a legend or caption.
- Never route a connector through a box. Remove crossings by moving boxes, not by coloring lines.
- Keep the flow in one direction, left to right or top to bottom, and keep parallel connectors at least 24px apart.
- Label a connector with a short verb as pinned text beside the middle of its longest segment, never on top of the line.

One node branching into two. The first node's right edge midpoint is (360, 280); the branches' left edge midpoints are (652, 120) and (652, 440). Both horizontal distances (292) are at least the vertical ones (160), so `elbow` draws horizontal–vertical–horizontal with the vertical leg at x 506:

```html
<section id="order-routing" style="gap: 64px; padding: 128px 128px 160px; font-family: 'Inter', sans-serif; color: #111827; background: #ffffff">
  <h2 style="font-size: 72px; line-height: 1.1">Every order is routed by market</h2>
  <div style="position: relative; height: 560px">
    <div style="position: absolute; left: 0px; top: 200px; width: 360px; height: 160px; display: flex; align-items: center; justify-content: center; background: #eff6ff; border: 2px solid #1d4ed8; border-radius: 16px">
      <p style="font-size: 32px">Order received</p>
    </div>
    <div style="position: absolute; left: 652px; top: 40px; width: 360px; height: 160px; display: flex; align-items: center; justify-content: center; background: #eff6ff; border: 2px solid #1d4ed8; border-radius: 16px">
      <p style="font-size: 32px">Hong Kong desk</p>
    </div>
    <div style="position: absolute; left: 652px; top: 360px; width: 360px; height: 160px; display: flex; align-items: center; justify-content: center; background: #eff6ff; border: 2px solid #1d4ed8; border-radius: 16px">
      <p style="font-size: 32px">US desk</p>
    </div>
    <x-connector x1="360" y1="280" x2="652" y2="120" route="elbow" style="color: #1d4ed8"></x-connector>
    <x-connector x1="360" y1="280" x2="652" y2="440" route="elbow" style="color: #1d4ed8"></x-connector>
  </div>
</section>
```

## Bar charts

Draw every bar on one baseline with one scale.

1. Choose an axis maximum: a round number at or above the largest value, such as 500 for a maximum of 437.
2. Fix the plot height, for example 480px, and compute scale = plot height ÷ axis maximum. Each bar's height is value × scale, rounded to whole px.
3. Place the bars in a flex row with `align-items: flex-end`, each bar a column `div` holding its value label above the bar `div`, with category labels in a matching row under the baseline; or pin each bar at `top = baseline − height`. The flex form keeps bars and labels out of the pinned-children limit. Give every bar the same width and gap, and draw the baseline as the plot row's 2px `border-bottom` or an `hr`.
4. Bars start at zero. With negative values, put the baseline inside the plot and draw those bars downward with the same scale.

Charts on one Slide that compare the same measure share one scale. Color the bar that carries the title's point with the accent and the rest with a muted tone.

With values 120, 150, 90 and 210 and an axis maximum of 250 over a 500px plot, the scale is 2 and the bars are 240, 300, 180 and 420px:

```html
<section id="revenue-bars" style="gap: 24px; padding: 128px 128px 160px; font-family: 'Inter', sans-serif; color: #111827; background: #ffffff">
  <h2 style="font-size: 72px; line-height: 1.1">Revenue reached a record in 2024</h2>
  <div style="display: flex; align-items: flex-end; gap: 48px; height: 560px; border-bottom: 2px solid #6b7280">
    <div style="display: flex; flex-direction: column; align-items: center; gap: 12px; width: 200px">
      <p style="font-size: 28px">120</p>
      <div style="width: 200px; height: 240px; background: #9ca3af"></div>
    </div>
    <div style="display: flex; flex-direction: column; align-items: center; gap: 12px; width: 200px">
      <p style="font-size: 28px">150</p>
      <div style="width: 200px; height: 300px; background: #9ca3af"></div>
    </div>
    <div style="display: flex; flex-direction: column; align-items: center; gap: 12px; width: 200px">
      <p style="font-size: 28px">90</p>
      <div style="width: 200px; height: 180px; background: #9ca3af"></div>
    </div>
    <div style="display: flex; flex-direction: column; align-items: center; gap: 12px; width: 200px">
      <p style="font-size: 28px; font-weight: 700">210</p>
      <div style="width: 200px; height: 420px; background: #1d4ed8"></div>
    </div>
  </div>
  <div style="display: flex; gap: 48px; font-size: 24px">
    <p style="width: 200px; text-align: center">2021</p>
    <p style="width: 200px; text-align: center">2022</p>
    <p style="width: 200px; text-align: center">2023</p>
    <p style="width: 200px; text-align: center">2024</p>
  </div>
  <p style="font-size: 24px; color: #4b5563">Revenue in HK$ millions. Source: [__], as of [__].</p>
</section>
```

## Lines and inline svg

Use inline `svg` for marks that HTML cannot draw: lines, areas and curves. Pin the `svg` and its labels in the same `position: relative` container, and set the `svg`'s `width` and `height` in its `style`, in px, equal to its `viewBox` size; a point (x, y) inside it then sits at the `svg`'s `left + x`, `top + y`, which is where its label goes. Compute points with the same scale method as bars. An `svg` holds shapes only, as the format reference lists, so every word stays Slide text; give it an `aria-label` that summarizes what it shows.

A series that rises from 40,000 to 80,000, drawn in a 1200×400 `viewBox` with zero at the bottom and a scale of 300px per 80,000, so 40,000 sits at y 250 and 80,000 at y 100. The `svg` is pinned at top 40px, so the last point (1200, 100) sits at (1200, 140) in the container, and its label starts just right of it:

```html
<section id="users-trend" style="gap: 48px; padding: 128px 128px 160px; font-family: 'Inter', sans-serif; color: #111827; background: #ffffff">
  <h2 style="font-size: 72px; line-height: 1.1">Monthly active users doubled in a year</h2>
  <div style="position: relative; height: 520px">
    <svg viewBox="0 0 1200 400" aria-label="Monthly active users rising from 40,000 in January to 80,000 in December" fill="none" stroke="#1d4ed8" stroke-width="6" stroke-linejoin="round" style="position: absolute; left: 0px; top: 40px; width: 1200px; height: 400px">
      <polyline points="0,250 400,213 800,160 1200,100" />
    </svg>
    <p style="position: absolute; left: 1224px; top: 120px; font-size: 28px; color: #1d4ed8">80,000 in December</p>
    <p style="position: absolute; left: 0px; top: 460px; font-size: 24px; color: #4b5563">January</p>
  </div>
</section>
```

## Labels, legends and data

Every word on a chart or diagram is real Slide text: axis labels, values, category names, legends and connector labels sit in `p` elements pinned at computed coordinates or in a flex row under the plot. Prefer direct labels at the end of a line or on top of a bar to a separate legend; when a legend is needed, use a small color swatch `div` next to each name.

Use only values from the user's material or an authorized source. Mark missing values with `[__]` rather than inventing a plausible number, and label illustrative data as illustrative. State the unit in the title or axis label, and the source and as-of date in a caption or the footer band. Keep the displayed precision of the source, and check that totals and percentages add up before saving.
