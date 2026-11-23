# Pivot tables

A pivot table puts the records of a table in groups and totals each group. It is one `PIVOT` formula in one cell,
which fills the cells under it and to its right and follows the table as that changes. Write it with `setPivotTable`,
which checks it first; people can then change the same pivot table in a panel of the page.

```
ArtifactEdit edit_sheet {"artifact_id":"<id>","base":2,"edits":[
  {"kind":"addSheet","name":"By region"},
  {"kind":"setPivotTable","sheet":"By region","topLeft":"A1","source":{"sheet":"Deals","headerRow":1},
   "rows":[{"column":"A"}],"values":[{"column":"C","total":"sum"}],
   "filters":[{"kind":"isOneOf","column":"B","values":["Won"]}]}]}
  → {"artifact_id":"<id>","revision":3,"changedNothing":[]}
ArtifactRead read_sheet {"artifact_id":"<id>","kind":"readCells","sheet":"By region","range":"A1:B9"}
  → {"revision":3,"sheet":"By region","range":"A1:B4","rows":{
      "1":[{"formula":"=PIVOT(,\"rows\",Deals!$A:$A,\"sum\",Deals!$C:$C,\"where\",Deals!$B:$B,\"is one of\",{\"Won\"})","value":"Region","spill":{"kind":"fills","to":"B4"}},{"spilledFrom":"A1","value":"Sum of Amount"}],
      "2":[{"spilledFrom":"A1","value":"Total"},{"spilledFrom":"A1","value":30.0}],
      "3":[{"spilledFrom":"A1","value":"East"},{"spilledFrom":"A1","value":20.0}],
      "4":[{"spilledFrom":"A1","value":"West"},{"spilledFrom":"A1","value":10.0}]},
    "pivotTables":[{"sheet":"By region","topLeft":"A1","source":{"sheet":"Deals","headerRow":1},"rows":[{"column":"A"}],
      "values":[{"column":"C","total":"sum"}],"filters":[{"kind":"isOneOf","column":"B","values":["Won"]}]}]}
```

- WHAT IT SHOWS: a row of headings, then the row of totals, then a row for each group. Across come the labels of `rows`,
  then a column for each of `values`, then a column for each group of `columns`. So totals come first, and stay in
  their cells as groups come and go. There are no subtotals. Its own words, such as Total and Sum of, follow the Sheets'
  locale.
- `source` is the table's sheet and the number of the row that names its columns. Which rows are records is worked out
  for you: the rows under that one, down to the first blank row or a footer of totals, which is left out when it is
  bold or holds formulas under typed records. A footer that is typed and not bold counts as a record: ask to make it
  bold first. Each `column` is the letters of a column of that table.
- `rows` takes any number of fields and `columns` one. With `columns`, `values` holds just one. A field takes `"by"` for
  dates (`day`, `month`, `quarter`, `year`), `"order"` (`ascending`, `descending`) and `"name"`, its heading. Dates
  grouped by day, month or quarter show as `2026-01-05`, `2026-01` and `2026 Q1`, a year as its number.
- A value's `total` is `sum`, `count`, `distinctCount`, `average`, `min`, `max` or `shareOfTotal`. Its
  `"order":"descending"` puts the rows in order by it, largest first. A share shows as a percent.
- FILTERS: a record counts if it passes all. `isOneOf` and `isNoneOf` list values as cells hold them: the bare number `5`
  and not `"5"`, `{"date":"2026-01-05"}`, `null` for blank; text matches with capitals aside, and the list holds at least
  one value (`filterHasNoValues`). `{"kind":"matchesCell","column":"B","sheet":"By region","cell":"B1"}` goes by what a
  cell holds, and keeps all while that is blank. That cell is above the pivot table or to its left
  (`cellInsideThePivotTable`), so this one starts at A3.
- GIVE IT A SHEET OF ITS OWN. It keeps the cells under it and to its right for as many groups as there are. A filled cell
  in its way refuses the edit (`pivotTableBlocked`), and `topLeft` takes a blank cell or a pivot table's first cell
  (`topLeftIsFilled`).
- TO CHANGE ONE, send all of it again with the same `topLeft`: an entry of `pivotTables`, which a read of its first cell
  gives, with `"kind":"setPivotTable"` added. Sent unchanged, it changes nothing (`nothingToChange`). A pivot table
  whose formula someone wrote to say more than this edit can is not listed. To take one away, write `null` in its
  first cell.
- Records written or inserted under the table count at once, as do records that change. It makes its headings and
  totals bold and widens its columns at each call if they are too narrow, and freezes nothing.
- Refused: `keyNotKnown`, `keyMissing`, `headerRowNotUnderstood`, `columnNotUnderstood`, `byNotKnown`, `orderNotKnown`,
  `totalNotKnown`, `tooManyColumnFields`, `oneValueWithColumns`, `pivotTableIsEmpty` (no rows and no values),
  `filterKindNotKnown` and `filterValueNotUnderstood`, beside the words above.
