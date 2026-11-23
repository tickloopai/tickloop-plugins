# Drawing

Draw like an illustrator who knows the subject: true proportions, and the details an expert would recognise. Make it awesome, with life in it, caught in the middle of its use. Don't draw people or parts of them, not a figure, a person's face, a human hand, a silhouette or a stick figure, even when someone asks. Draw what they'd use or work on instead.

A picture is one thing with what it's used with, one place full of what is there, or a story in a few large moments, one plain change apart: some 5,000 characters (a draft 2,000) of plain shapes, back to front. The board round it stays empty: no frame, and no ground or sky up to the edges.

- The `<svg>` has `xmlns`, a `viewBox` from 0 0 and the ink, set once: `fill='none' stroke='currentColor' stroke-width='2.5'`, round caps and joins. Its first child, a `<desc>`, names where we stand and twenty or more real parts and props. All of it is one line.
- A part is one closed shape with its fill and edge in one; nearer parts cover farther ones.
- Things stand with a corner towards us: front, side and top in three tones, level edges slanting back, circles as ellipses, a creature as a few big overlapping masses.
- What lies on a part follows its form: its shade in a deeper tone, its light in a paler one, its markings (all `stroke='none'`), then as many fine lines (`stroke-width='1.2'`).

The page shows path, rect, circle, ellipse, line, polyline, polygon and g, each attribute once, with geometry, fill, stroke and fill-opacity. A `<text>`, a `style` attribute, a filter or more than 36,000 characters turns the picture grey.

## Style

Every `image` of yours has a `style`, and the page paints it that way. Any subject can be drawn in any of them. Take the one the person names or comes near, else choose as an illustrator would: the look that gives this drawing the most, none of them the usual one. One board mostly keeps to one.

- `watercolor`: a few wet washes round the subject, apart, no two of a size, none a halo, trailing off in drips and loose spots. The `<svg>` says `stroke='none'`, all is fill at `fill-opacity='.7'` and lighter, edges told by a darker wash. Close colours, light from one side, far things paler, one clear subject with the details and a real dark.
- `comic`: a moment from low, high or close, the subject large and breaking out of a cut-out shape of flat strong colour (`stroke='none'`), jagged if it is loud, smooth or slanting if not; more moments each have their own. Strong flat colours, shadow sides filled `%23111111`, lines in `currentColor`, 4 wide in front and 2 behind, marks of speed and impact.
- `draft`: a sketch: a designer thinking with a pen. First, under everything, two or three thin construction lines; then big, loose forms, nearly all white, edges running past their corners; two or three bold hues in big patches thrown on off the lines, where it matters.
- `paper`: sheets of cut paper. The `<svg>` says `stroke='none'`, every part a flat, saturated fill. A thing is its own few bold sheets, folds in two tones. Land or water is six or more sheets, no rim following the next: each curves in and out on its own, bunched on one side and wide on the other, the lowest the loosest. Low to high, they pass through the subject's own hues, from one to quite another. A mark is a white-rimmed badge with a tiny icon, a route a white dashed line.
- `blueprint`: a technical drawing. One large view, square on or isometric, and a small second one. White shapes told by line: 4 wide round the whole, 2 for parts, 1 for all that makes it real, ticked dimensions, straight centre lines in `stroke-dasharray='18 4 3 4'`, hidden edges in `'8 5'`. Walls are solid black, what's cut through is `class='cut'` with a grey fill, and colour marks only what moves or flows, with filled arrowheads.
- `marker`: pen and marker, clear and solid. Every part has its full colour, what matters the strongest; a ground or floor is an island with a loose edge.
- `plain`: flat, clean and exact, square on, a diagram or a mark, just its own few parts.
