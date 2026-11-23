# Rows and columns

These are edits of an `edit_sheet`, beside the ones that the Skill shows. Each but `sortCells` is of whole rows or
columns: those that move or go take along what they hold and how they look.

```
ArtifactEdit edit_sheet {"artifact_id":"<id>","base":2,"edits":[
  {"kind":"sortRows","sheet":"Budget","rows":"2:4","byColumn":"B","direction":"descending"}]}
  → {"artifact_id":"<id>","revision":3,"changedNothing":[]}
ArtifactRead read_sheet {"artifact_id":"<id>","kind":"readCells","sheet":"Budget","range":"A1:B5"}
  → {"revision":3,"sheet":"Budget","range":"A1:B5","rows":{"1":["Item","Cost"],"2":["Rent",1200.0],"3":["Food",400.0],"4":["Gas",90.0],"5":["Total",{"formula":"=SUM(B2:B4)","value":1690.0}]}}
ArtifactEdit edit_sheet {"artifact_id":"<id>","base":3,"edits":[
  {"kind":"insertRows","sheet":"Budget","besideRow":4,"side":"above","count":1},
  {"kind":"writeCells","sheet":"Budget","topLeft":"A4","rows":[["Bus",60]]}]}
  → {"artifact_id":"<id>","revision":4,"changedNothing":[]}
ArtifactRead read_sheet {"artifact_id":"<id>","kind":"readCells","sheet":"Budget","range":"A4:B6"}
  → {"revision":4,"sheet":"Budget","range":"A4:B6","rows":{"4":["Bus",60.0],"5":["Gas",90.0],"6":["Total",{"formula":"=SUM(B2:B5)","value":1750.0}]}}
```

- ADDRESSES CHANGE for the edits after an insert, a sort, a move or a delete. After an insert, count on from it: `A4`
  above is in the new row. Put any other of them last in its `edit_sheet`, or read again before you write.
- TO INSERT ROWS: `insertRows` puts `count` blank rows directly `above` or `below` `besideRow`, and the rows after them
  move down. Fill them in the same `edit_sheet`, as above. `besideRow` is a row on the sheet (`outsideTheSheet`), and
  `side` is `above` or `below` (`sideNotUnderstood`).
- NEW ROWS LOOK AS `besideRow` DOES, cell for cell, with its dropdowns and checkboxes, the cells blank, and they are in
  its groups. So name a row of the kind that you add:
  for a new first item, the old first item and `above`, not the heading and `below`.
- A BLANK ROW UNDER A TABLE seldom has the table's looks, dropdowns and checkboxes. A row inserted beside one of its
  rows has them all, at the table's end too.
- FORMULAS AFTER AN INSERT: one that names a cell follows it. A range covers new rows that lie between two of its rows,
  as `=SUM(B2:B5)` above does. No range covers rows inserted above its first or below its last. After you add a first or
  a last item, read the total, and write it again if it left the row out. A row inserted there for a total or a note
  needs the same: write them again.
- TO INSERT COLUMNS: `{"kind":"insertColumns","sheet":"Budget","besideColumn":"B","side":"right","count":1}` puts in a
  blank column C, and `left` a blank column B. All is as for rows, but that a range covers new columns only between two
  of its own, and that `side` is `left` or `right`. The new cells get the look of `besideColumn`, row for row, with its
  dropdowns and checkboxes. Its width is not copied, so fit it once it is filled ([formats](formats.md)).
- WHAT LIES OVER THE CELLS FOLLOWS THEM through an insert, a move or a delete: a declared table
  ([building](building.md)) grows over rows and columns inserted inside it, and shrinks over those deleted, people stay
  in their cells, and conditional formats move with their cells ([conditional formats](conditional-formats.md)).
- A SHEET GROWS BY ITSELF ONLY FOR A `writeCells` OR A `copyCells`, by rows and columns that look plain. Before another
  edit that needs the room, write a `null` at the far corner, or insert `below` the last row or `right` of the last
  column, which `readSheets` counts.
- TO SORT ROWS: `sortRows` puts `rows` in the order of what each holds in `byColumn`. No row is taken for a heading or a
  total, but that frozen rows stay: name only the rows between them, as `2:4` above.
- THE ORDER: `ascending` is numbers from the smallest (a date is a number), then text from A, capitals aside, then
  `FALSE`, then `TRUE`. `descending` turns that round. Either way errors come after those and blank cells last, and rows
  that tie keep their order. A formula counts as what it comes to. A column that one formula fills down several rows is
  refused.
- FORMULAS AFTER A SORT read as if each had been copied to the row where it now lies. `=B2*2` in row 2 that lands in row
  4 reads `=B4*2`, so a formula that reads its own row still does. One that reads another row, as `=B1` in row 2, reads
  another cell afterwards: before you sort, put `$` before the row of what must not shift (`=B$1`). What it reads in
  another sheet does not shift. A formula in a row that stays keeps its addresses, as `=SUM(B2:B4)` above does, so `=B2`
  there reads what the sort put in B2.
- TO SORT ONE TABLE OF TWO THAT LIE SIDE BY SIDE:
  `{"kind":"sortCells","sheet":"Budget","range":"A2:B4","byColumn":"A","direction":"ascending"}` sorts the cells of
  `range` alone, by one of its own columns. The rows stay, and so does every cell outside `range`, so what belongs to a
  row and lies outside is left behind. `sortRows` takes far more rows. The order, and the formulas in `range`, are as for
  `sortRows`. A `range` that holds a merged cell is refused.
- TO MOVE ROWS OR COLUMNS: `{"kind":"moveRows","sheet":"Budget","rows":"3:4","afterRow":1}` puts rows 3 and 4 directly
  under row 1. `moveColumns` takes `"columns":"C:D"` and `"afterColumn":"A"`. `null` is the start of the sheet. A
  formula that names a cell follows it, and a range covers the rows that stay in it: one that moves out leaves it.
- A move or a sort that would split a merged range is refused.
- TO DELETE ROWS OR COLUMNS: `{"kind":"deleteRows","sheet":"Budget","rows":"3:4"}` takes rows 3 and 4 away, and the rows
  below move up. `deleteColumns` takes `"columns":"C:D"`. A formula that names a deleted cell comes to `#REF!`, and a
  range covers what is left of it. Of rows that lie apart, delete the one furthest down first. A sheet keeps one row and
  one column (`outsideTheSheet`). To empty cells and keep their rows, write `null`s.
- TO GROUP ROWS OR COLUMNS: `{"kind":"groupRows","sheet":"Budget","groups":[{"rows":"2:3","isCollapsed":false}]}` puts
  rows 2 and 3 in a group, which people collapse and expand with a mark beside the row numbers. `groupColumns` takes
  `"columns":"C:N"`. Each entry holds just those two keys (`groupNotUnderstood`).
- TO COLLAPSE OR EXPAND, send the entry, as `readSheets` gives it, with the other `isCollapsed`. An entry says what is to
  be so: it makes a group only where none covers just those rows.
- TO HIDE ROWS OR COLUMNS, make them a collapsed group:
  `{"kind":"groupColumns","sheet":"Budget","groups":[{"columns":"C:D","isCollapsed":true}]}`. No call hides in another
  way, and the page has no command to hide either: there people group and then collapse. The group's mark stays in view,
  and a press on it brings them back. For rows that cross an edge of a group, send one entry for the part on each side of
  it. To unhide, expand the group, or ungroup it, which takes the mark away too.
- COLLAPSING IS FOR EVERYONE who opens the Sheets, and changes no value and no address: you read and write collapsed rows
  like any others.
- `readSheets` lists `rowGroups` and `columnGroups` as they lie now. Groups nest, at most 7 deep (`groupsTooDeep`), and
  never partly overlap (`groupsOverlap`).
- TO UNGROUP: `{"kind":"ungroupRows","sheet":"Budget","groups":["2:3"]}` names each group by just the rows that it
  covers. `ungroupColumns` takes letters. The rows stay.
- A SORT TAKES COLLAPSED ROWS ALONG, and each row keeps its groups: a hidden row stays hidden where it lands. A group
  whose rows land apart becomes several, which `readSheets` then lists. A move or a delete does the same to the groups.
