# Charts in a doc

A chart in a doc is a `chart` block: a fenced code block whose info string is `chart` and whose body is ONE JSON object holding the chart's rows (`sources`) and its `definition`. The editor, the share view and every export (HTML, PDF, PNG, Word) draw it from those rows; readers hover a mark to see its value. You write rows and a definition, never a picture: no image, no SVG, no script, no page styling, and never a screenshot or render of a chart.

## What to draw, before how

- The one or two measures this doc's reader decides from, not every column its table offers: a table holds everything, a reader decides from one or two things, and a chart of all the table holds only repeats the table. A total is split into its parts only when the parts are the point.
- A rate, a share or a ratio the reader would otherwise work out from the columns is computed and drawn: the working-out is what the chart saves them. The definition NAMES columns and never computes, so totals, shares, differences, running sums, sorting and top-N are computed when you write the rows, as their own columns, from the numbers you were given; a total the doc or the ask also states must tie to them, and a mismatch is said in the doc, not drawn over.
- A further chart in the same doc is there because the reader decides something from it that the charts before it do not show.

## The look

A chart its field's reader grasps at a glance:

- The finding in the title, with its number (`"Signups peaked at 420 in W4"`; at most 40 characters, the rest goes in `note`): they have the point before the marks and check it against them.
- The values on the marks (`labels` with the measured column) or a light axis, not both on a short series.
- What they check the series against ON the chart, as a drawn, labelled mark: the limit, target or reference level is a `rule` annotation drawn from its own one-row source, never typed as a number elsewhere.
- Labels on the few points the finding rests on: a `text` label on a line marks its end; a column label on every bar of a long series hides them.
- A small source line saying where the numbers come from: `note` (`"Typed in chat · September 2026"`, `"Q3 export from the user's upload"`).
- An honest axis: bars and areas are measured from zero, and `min`/`max` pin the y axis ends only to show the whole range (a share: `min: 0, max: 1`).
- Colour is chosen by the readers: one series in one colour, several series in a fixed order. There are no colour keys.

The chart carries its numbers ONCE: no table, bullet list or later paragraph restating the plotted values row by row (the lead's answer figure aside); prose after a chart adds what the picture cannot show. A table you find in a person's doc is theirs, not a second copy: it stays, the chart drawn from it sits above or below it, and removing it is their call.

## The rows

- Rows are typed in from the numbers the user gave you or the sources you opened, never invented; missing data is asked for or written as sample rows marked as sample in `note`.
- One row per thing drawn. In rows you shape, a series name is a VALUE (a row per series and period: `{"week": "W1", "series": "Web", "signups": 140}`) split by `group` or `stack`, so a renamed or added series redraws with its name. Measures in their own columns (a column per measure) are one mark per column, EACH with a `title`.
- Values are text, numbers, true/false or null; a null y draws nothing (a gap in a line). Dates are `YYYY`, `YYYY-MM` or `YYYY-MM-DD`, a whole period dated at its start (`2026-07-01` for July). Ratios are written as ratios (`0.274`) and shown as percentages by the format.
- At most 4 sources and 2000 rows each; rows are drawn in the order written, so write them in the order to show.

## The grammar

```
{"sources": {"<name>": {"kind": "data", "data": [{…}, …]}, …},   // 1–4 sources of inline rows
 "definition": Chart}
Chart = {"kind": "chart", "source": "<sources key>", "title"?, "note"?,   // title ≤ 40 characters, note ≤ 200
  "axes": {"x": [XAxis], "y"?: [YAxis]},   // exactly one x, at most one y
  "marks": [Mark ×1–8], "annotations"?: [Rule ×≤8]}
XAxis = {"type": "band", "column", "title"?}   // categories as written, in row order
      | {"type": "time", "column", "period"?: "day"|"week"|"month"|"quarter"|"year", "format"?: TimeFormat, "title"?}
      | {"type": "linear", "column", "format"?: NumberFormat, "title"?}   // numbers; lines, areas and points only
YAxis = {"type"?: "linear", "title"?, "format"?: NumberFormat, "min"?, "max"?}   // a row outside min/max is refused
Mark  = {"type": "bar"|"line"|"area"|"point", "y": "<number column>", "source"?: "<another source with the x column>",
         "title"?, "group"?: Split, "stack"?: Split, "labels"?: [Label ×≤2]}
         // group colours a series per value (bars side by side, lines overlaid); stack layers bars or areas from zero;
         // title names an unsplit mark in the legend (required when there are several marks), never a split one
Split = {"by": "<column>", "title"?}   // the split's title heads the legend
Label = {"kind": "column", "column", "format"?} | {"kind": "text", "text"}   // a text label marks the series' last point
Rule  = {"kind": "rule", "axis": "y"|"x", "value": "<column>", "source"?, "labels"?: [Label ×≤2]}   // a dashed line per row of its source (≤ 8 rows)
NumberFormat = {"kind": "number", "spec"?: "~s"|",d"|".1f"|".0%"|"+.1%", "prefix"?: "$", "suffix"?: "M"}   // affixes ≤ 4 characters
TimeFormat   = {"kind": "time", "spec": "%b %Y"}   // %Y %y %m %d %e %b %B %q
```

Any other key is refused by name. Not in Doc charts (refused): a second y axis, log axes, horizontal bars, small multiples, span annotations, tones, colours, sorting keys, stat tiles, tables in the definition, rows read from a file. A heat map, a map, a network or anything the grammar cannot say belongs in a Page.

## One example

Numbers typed in chat, bars with their values, a target level:

````
## Signups

```chart
{"sources": {"rows": {"kind": "data", "data": [{"week": "W1", "signups": 240}, {"week": "W2", "signups": 310}, {"week": "W3", "signups": 280}, {"week": "W4", "signups": 420}]},
             "target": {"kind": "data", "data": [{"level": 400, "label": "Target 400"}]}},
 "definition": {"kind": "chart", "source": "rows", "title": "Signups peaked at 420 in W4", "note": "Typed in chat · September 2026",
   "axes": {"x": [{"type": "band", "column": "week"}], "y": [{"title": "Signups", "format": {"kind": "number", "spec": ",d"}}]},
   "marks": [{"type": "bar", "y": "signups", "labels": [{"kind": "column", "column": "signups"}]}],
   "annotations": [{"kind": "rule", "axis": "y", "value": "level", "source": "target", "labels": [{"kind": "column", "column": "label"}]}]}}
```

Signups crossed the target once, in the last week.
````

The chart block goes in the section it belongs to, written in the same patch as the section's text: a heading, the chart, the sentence that reads it.

## Saving and changing a chart

- A save checks every chart block before anything is written. A chart the readers could not draw refuses the whole save with `chart block <n> cannot be drawn: <path>: <reason>` (`definition.marks[0].y: no row of source "rows" has the column "signup" (its columns: signups, week)`): fix that path and send the same write again. A refused save changes nothing.
- A saved chart is drawn; do not render, convert or screenshot it to check it, and do not install anything.
- A later change touches only its block: `ArtifactEdit patch` with one `replace` entry targeting the chart block by its `id` and `hash`, whose `text` is the whole block again (the fence, the JSON with every row, the closing fence). One number changed is that one value changed in the rows; the title, the marks and everything drawn from the rows follow.
- Restyling or rebuilding a chart keeps its rows as they are: change the definition, not the numbers.
