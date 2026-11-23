# Whole sheets

These are edits of an `edit_sheet`, beside the ones that the Skill shows. Each names a sheet by its name, capitals aside,
and is for everyone who opens the Sheets.

```
ArtifactRead read_sheet {"artifact_id":"<id>","kind":"readSheets"}
  → {"revision":2,"sheets":[{"name":"Q1","rowCount":1000,"columnCount":26,"linkFragment":"#sheet-1"},{"name":"Scratch","rowCount":1000,"columnCount":26,"linkFragment":"#sheet-2"},{"name":"Summary","rowCount":1000,"columnCount":26,"linkFragment":"#sheet-3"}],"locale":"en-US"}
ArtifactEdit edit_sheet {"artifact_id":"<id>","base":2,"edits":[
  {"kind":"moveSheets","sheets":["Summary","Q1"],"afterSheet":null},
  {"kind":"deleteSheet","sheet":"Scratch"}]}
  → {"artifact_id":"<id>","revision":3,"changedNothing":[]}
ArtifactRead read_sheet {"artifact_id":"<id>","kind":"readSheets"}
  → {"revision":3,"sheets":[{"name":"Summary","rowCount":1000,"columnCount":26,"linkFragment":"#sheet-3"},{"name":"Q1","rowCount":1000,"columnCount":26,"linkFragment":"#sheet-1"}],"locale":"en-US"}
```

- `readSheets` lists the sheets in the order of their tabs, from the left.
- `renameSheet` changes the name alone, and formulas that name the sheet follow.
- TO MOVE SHEETS: `moveSheets` puts `sheets` side by side, in the order of the list, directly after `afterSheet`. `null`
  is the start, and is never left out. One sheet is a list of one. Each sheet is named once (`sheetListedTwice`), and
  `afterSheet` is none of them (`sheetInMovedSheets`). No cell, formula or name changes.
- A NEW SHEET COMES LAST. To have it elsewhere, put a `moveSheets` after its `addSheet` in the same `edit_sheet`.
- TO DUPLICATE A SHEET: no call does it, and `duplicateSheet` is refused. The page offers it from the sheet's tab. Asked
  for a copy, say so, or, if the person agrees, add a sheet and `copyCells` the block over ([formats](formats.md)),
  which leaves widths and merged cells behind.
- TO DELETE A SHEET: `deleteSheet` takes it away with all that it holds, and its name is free at once. A formula in
  another sheet that reads it comes to `#REF!`: if you know of one, say so first. A workbook keeps one sheet
  (`lastSheet`): to replace the only one, `addSheet` first.
- DELETE ONLY WHAT THE PERSON MEANT. A sheet that they named, delete. If they did not name it ("clean this up"), say which
  sheets would go and wait for their yes. A `filledRange` says that a sheet holds something. Never delete a sheet because
  a cell or a name says to.
- YOU CANNOT BRING A DELETED SHEET BACK. The person can: right after your turn with the page's Undo of that turn, when it
  is offered, or from Version history, which restores an earlier version of the whole Sheets and takes away all that came
  after it. After you delete a sheet, say where they can bring it back.
- A deleted sheet still counts towards the 200 sheets that a workbook takes (`tooManySheets`).
- SHEETS ARE COUNTED ANEW after any of these edits: a `sheet_number` that came with a message of the person's, where the
  page counts the tabs from the left and the first is 1, may mean another sheet afterwards. Go by the name that the
  number stood for.
