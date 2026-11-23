# Building a table

What you cannot know or see while you build: the order that the calls have to go in, how a sheet is drawn, and what the
person sees meanwhile. The example uses the calls that most tables need, so a plain table takes no other reference.
`base` and what a cell holds are as in the Skill.

## The order of a build

Here the create receipt of new Sheets gave revision 1, so the first update takes it as its `base`, with no read.

```
ArtifactEdit edit_sheet {"artifact_id":"<id>","base":1,"edits":[
  {"kind":"renameSheet","sheet":"Sheet1","name":"Tasks"},
  {"kind":"writeCells","sheet":"Tasks","topLeft":"A1","rows":[["Task","Owner","Due","Status","Done","Hours","Notes"]]},
  {"kind":"formatCells","sheet":"Tasks","ranges":["A1:G1"],"format":{"fillColor":{"kind":"rgb","hex":"#f3f3f3"}}},
  {"kind":"setCellTable","sheet":"Tasks","cellTable":{"columns":"A:G","headerRows":"1","footerRows":null}}]}
  → {"artifact_id":"<id>","revision":2,"changedNothing":[]}
ArtifactEdit edit_sheet {"artifact_id":"<id>","base":2,"edits":[
  {"kind":"writeCells","sheet":"Tasks","topLeft":"A2","rows":[
    ["Draft the brief","Ana","2026-03-02","Done",true,3,"Sent to legal on Friday. They asked for the vendor list and the renewal dates."],
    ["Book the venue","Raj","2026-03-09","In progress",false,1.5,null],
    ["Send invitations","Ana","2026-03-16","To do",false,2,null]]},
  {"kind":"writeCells","sheet":"Tasks","topLeft":"I1","rows":[["Hours left","=SUMIFS(F:F,E:E,FALSE)"]]},
  {"kind":"makeDropdown","sheet":"Tasks","range":"D2:D4","options":[
    {"label":"To do","color":{"kind":"standard","hue":"gray","shade":200}},
    {"label":"In progress","color":{"kind":"standard","hue":"blue","shade":200}},
    {"label":"Done","color":{"kind":"standard","hue":"green","shade":200}}]},
  {"kind":"formatCells","sheet":"Tasks","ranges":["E2:E4"],"format":{"cellControl":{"kind":"checkbox"}}},
  {"kind":"formatCells","sheet":"Tasks","ranges":["F2:F200"],"format":{"numberFormat":{"pattern":"0.0"}}},
  {"kind":"formatCells","sheet":"Tasks","ranges":["G2:G200"],"format":{"alignment":{"wrap":"wrap"}}},
  {"kind":"formatCells","sheet":"Tasks","ranges":["I1"],"format":{"font":{"bold":true}}},
  {"kind":"setColumnWidths","sheet":"Tasks","columns":"G","widthInPixels":320},
  {"kind":"fitColumns","sheet":"Tasks","columns":"A:F"},
  {"kind":"fitColumns","sheet":"Tasks","columns":"I:J"}]}
  → {"artifact_id":"<id>","revision":3,"changedNothing":[]}
ArtifactRead read_sheet {"artifact_id":"<id>","kind":"readCells","sheet":"Tasks","range":"I1:J1"}
  → {"revision":3,"sheet":"Tasks","range":"I1:J1","rows":{"1":["Hours left",{"formula":"=SUMIFS(F:F,E:E,FALSE)","value":3.5}]}}
```

1. THE NAME AND THE HEADERS GO FIRST, in an update of their own, for a table of more than a few rows. The person sees
   each update land, so they see what is coming while the rows are still on the way, and can steer. There is no need to
   wait for them. In new Sheets, `setTimeZone` then `setLocale` lead if you know where they are
   ([functions](functions.md)). Name the Sheets themselves too, if they still read "Untitled" (`ArtifactEdit rename`).
2. THEN THE ROWS AND ALL THAT GOES WITH THEM, in one update: cells, formulas, dropdowns
   ([dropdowns](dropdowns.md)), checkboxes, number formats, wrapping, borders. Past what one update holds (the Skill's
   "The rules of an update"), the rows go in parts, from the top.
3. A FIT COMES LAST, once the columns hold what they will show. After a very large table, or one with many formulas, it
   goes alone.
4. A READ OF THE FORMULAS shows what they come to.
5. A CONDITIONAL FORMAT TAKES AN UPDATE OF ITS OWN, which starts from a read
   ([conditional formats](conditional-formats.md)).
- DECLARE THE TABLE WITH ITS HEADERS. `setCellTable` says what no cell can: which rows name the columns, which columns
  are the table's, and which rows at its foot are totals, as `"footerRows":"9"` (`null` for none). It changes no cell.
  Still fill the header. A person's filter then goes by that and by no guess. The records are not declared: they run
  from under the header to the footer, or with no footer down to the last row that holds anything in the table's
  columns. So a total under the records needs `footerRows`, a row inserted over the footer is a record at once, and a
  column inserted inside the table widens it. Send one for each table of a sheet. `readSheets` gives them as they lie
  now, as `cellTables`, each with the `cellTableId` that says all three anew, or takes the table away with
  `"cellTable":null`.
- `cellTable` holds just its three keys, with `footerRows` under `headerRows` (`cellTableNotUnderstood`), and `columns`
  names both ends, as `"A:G"` or `"C:C"`. Two tables never share a cell (`cellTablesOverlap`): change the one that is
  there by its `cellTableId`. A `cellTableId` that is not the sheet's is refused (`cellTableNotFound`), and a sheet
  declares at most 50 tables (`tooManyCellTables`).
- A FORMULA THAT NAMES A CELL PAST THE SHEET'S LAST ROW OR COLUMN, OR A SHEET THAT IS NOT THERE YET, IS AN ERROR.
  `readSheets` gives the sheet's size. A `null` written at the far corner in an earlier edit makes the room, and a sheet
  is added before the formulas that name it.
- `{"kind":"setSheetSettings","sheet":"Tasks","settings":{"lastFrozenRow":1}}` keeps the rows down to that one in view
  however far anyone scrolls, for everyone, and `"lastFrozenColumn":"A"` does that for columns. `null` unfreezes, and a
  key that is left out is left alone. At least one row and one column stay unfrozen (`outsideTheSheet`).

## How a sheet is drawn

No read gives you a picture of the cells, so this is what the page does with them.

- A COLUMN STARTS ABOUT 100 PIXELS WIDE, which holds some 13 letters or 11 digits of the font that cells start with. A
  row of plain text is about 24 pixels tall, or less for a person who has set the page to tighter rows, which only they
  see.
- TEXT THAT IS TOO LONG for its column runs on over the blank cells beside it, and is cut where the next cell holds
  something. So in a table, long text is cut. Wrapped, it breaks at the column's width and the row grows, with no height
  from you. Notes and descriptions read well wrapped in a column of 240 to 400 pixels.
- A NUMBER NEVER RUNS ON OVER THE NEXT CELL. In a column that is too narrow, it can read as another value or not at all.
  `fitColumns` gives each column what it needs, and counts a text on one line for at most 360 pixels. Wrapped text does
  not widen its column.
- Text is drawn at the left, numbers, dates and times at the right, and `TRUE`, `FALSE` and errors in the middle, unless
  `horizontal` says otherwise. A checkbox is in the middle whatever it says.
- PEOPLE OFTEN HAVE THE SHEETS IN A PANE BESIDE THE CHAT, or on a phone, where only the first few columns are in view.
  Frozen rows and columns stay in view, and take that room from the rest.
- PEOPLE LAND ON THE FIRST TAB. Sheets open there.
- A TABLE'S HEADER IS TOLD BY ITS FILL and by `setCellTable`. Give a header row a pale fill, as `#f3f3f3` above, so
  that the page and the person know which row names the columns. A line elsewhere, as over a total, is
  `{"kind":"setBorders","sheet":"Tasks","range":"A9:G9","edges":"top","border":{"kind":"line","style":"thin","color":{"kind":"none"}}}`.
- TWO TABLES SIDE BY SIDE TAKE TWO BLANK COLUMNS BETWEEN THEM, which may be narrow. Over one, the page may draw them as
  one table.
- THE PAGE HAS A LIGHT THEME AND A DARK ONE. A color is kept as it looks on a light sheet, so dark text on a pale fill
  reads best in both. A standard color's `hue` is gray, red, orange, yellow, green, teal, blue, purple or magenta. Of its
  shades, 100 to 300 are pale enough for a fill under text, and 600 is deep enough for text. Text in 800 is hard to tell
  from plain text.
- A dropdown's option is drawn as a pill in its color. A checkbox is drawn only over `true` or `false`.
- A DROPDOWN SHOWS IN ITS BLANK CELLS TOO. Anyone who can edit sees each as an empty pill with an arrow, as wide as the
  cell, which stops long text beside it.

## What the calls count on

- `sortRows` MOVES WHOLE ROWS, so two tables side by side are sorted together, and a title, a total or a blank row among
  the rows that it names ends up among the records. `sortCells` sorts one range and leaves the cells beside it
  ([rows and columns](rows-and-columns.md)).
- A WHOLE COLUMN, `=SUM(F:F)`, covers rows that are added later anywhere, with the header: fine for a sum under a header
  in words, from a cell outside that column. A total under its column, `=SUM(B2:B9)`, covers rows inserted among the
  records or at their edge, and no others. Put the totals of a table that will grow above it, or beside it over the
  whole column. A range with no end, `F2:F`, is an error here: name the whole column or both corners.
- A ROW THAT YOU WRITE UNDER A TABLE TAKES NO LOOKS, dropdowns or checkboxes from the rows above it: give it the
  table's in the same update, or insert it beside a record, which copies that record's
  ([rows and columns](rows-and-columns.md)). So a dropdown's range ends with the last record or with the row over a
  total. A table that the person asked to have empty, or with one record, has its dropdowns on ten rows.
- A CHECKBOX WRITES `false` IN EACH BLANK CELL, which formulas count, so blank rows are better left out of it.
- A sort or a move that would split a merged range is refused, and a merged range in the way of a formula's list blocks
  it.
