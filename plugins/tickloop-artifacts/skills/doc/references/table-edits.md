# Edit a table without changing its layout

Read the doc with `ArtifactRead read` and identify the table block and current hash. For one cell, use `ArtifactEdit` with the real IDs and hash returned by the read. For example, this changes the text in the second row, third cell:

```json
{"op":"patch","artifact_id":"<artifact ID>","patches":[{"type":"setCell","target":"<table block ID>","expected_hash":"<hash from read>","row":1,"column":2,"text":"阿岚"}]}
```

Both indexes start at zero. Count cells present in that row; a merged cell counts once. Identify the row by its content before using its index. On a conflict, read the table again, locate the intended row and cell, and retry with the fresh hash only if the edit still makes sense. Changes to column width, row height, fill, alignment, merged cells or the table’s width setting should survive a text edit. Use the rich table representation when the user actually requests a layout change. Rebuilding a table as pipes cannot represent all those settings. A table whose read carries `lossy: true` holds something even its Markdown cannot show (its `dropped` names it, or says `text`, `structure`, `all` or `unknown` when it cannot name a part): read it with `"block":"<table block ID>","as":"json"` to see every cell with its attributes before you change it.

## Dates and dropdown choices

A date or dropdown can appear between words or inside a table cell. Use a calendar date in the range 0001–9999, without a time zone:

```markdown
截止 <time datetime="2026-11-30">2026-11-30</time>
```

Keep the option values stable when renaming or selecting a dropdown choice. The attribute holds a JSON array. Quote HTML attribute values, escape their contents, and use the selected option’s label as visible text. To change a status, preserve the complete list of options in the cell and change the selected value and displayed label.

```markdown
<span data-doc-dropdown="[{&quot;value&quot;:&quot;todo&quot;,&quot;label&quot;:&quot;未开始&quot;,&quot;color&quot;:&quot;#9ebbf3&quot;},{&quot;value&quot;:&quot;done&quot;,&quot;label&quot;:&quot;已完成&quot;,&quot;color&quot;:&quot;#81c89a&quot;}]" data-value="done">已完成</span>
```

Include 1–64 choices. Each value must be unique. Values and labels accept up to 128 Unicode characters and must contain visible text. A color, when given, is a six-digit hex color. In a pipe table encode a literal pipe in a label or attribute as `&#124;`. In a sentence that only mentions a date or status as prose, plain text works.
