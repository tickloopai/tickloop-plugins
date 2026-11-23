# Tracing a number, and pointing at cells

`readTrace` follows formulas across every sheet, through as many formulas as there are. Its `precedents` are what the
cells of `range` are worked out from, and its `dependents` what is worked out from them.

```
ArtifactRead read_sheet {"artifact_id":"<id>","kind":"readTrace","sheet":"Plan","range":"B4:D4"}
  → {"revision":3,"url":"https://…/artifacts/<id>","sheet":"Plan","range":"B4:D4",
     "precedents":{"blocks":[
       {"sheet":"Plan","range":"B1:B2","steps":1,"firstCell":0.5,"textToTheLeft":"Growth"},
       {"sheet":"Plan","range":"C2","steps":1,"firstCell":{"formula":"=B2*(1+$B$1)","value":150.0},"textToTheLeft":"Price"},
       {"sheet":"Plan","range":"D2","steps":1,"firstCell":130.0,"textToTheLeft":"Price"},
       {"sheet":"Plan","range":"B3:D3","steps":1,"firstCell":5.0,"textToTheLeft":"Units"}]},
     "dependents":{"blocks":[
       {"sheet":"Summary","range":"B1","steps":1,"firstCell":{"formula":"=SUM(Plan!B4:D4)","value":2310.0},"textToTheLeft":"Total"}]}}
```

- A BLOCK is cells side by side that all hold copies of one formula, or all hold what was typed. So a number typed over
  a formula is a block of its own, as D2 is here, and a trace stops at it. `firstCell` is its top left cell as
  `readCells` gives it. `null` is a blank cell, listed where a formula names it alone.
- `steps` counts the references from `range` to the block's nearest cell, and the nearest blocks come first. No cell of
  `range` is listed.
- `textToTheLeft` and `textAbove` are the start of the nearest text in the first cell's row and column. Either may be
  no label of the block, and either is left out when there is none.
- A formula counts as reading all that it names: the whole table of a lookup, and both branches of an `IF`. Not where it
  asks only for a place or a size, as `ROW` and `ROWS` do. A cell that a formula fills stands for that formula. Charts
  and conditional formats are not followed.
- `"notEveryBlockIsListed":true` beside `blocks` says that there is more, or may be: one answer lists at most 100 blocks
  each way. A listed block may then reach further than it says. Ask again from a block that is listed. Until then, do
  not say that nothing else leads to a cell or from it.
- `range` is at most 10,000 cells (`readTooLarge`).

## Pointing at cells

A link can light cells up: after the Sheets' link, which every read and receipt gives as `url`, put the sheet's
`linkFragment` from `readSheets`, then each range after a `~`, with `-` in place of `:`, in at most 128 characters
after the `#`. `[FY2 price](<url>#sheet-1~A2-D2~B1)` opens sheet 1 with A2:D2 and B1 lit up until the person clicks
the grid.
