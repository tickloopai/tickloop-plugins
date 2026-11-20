# Toggles, image sizes and row heights in a doc

Use the forms below when writing Markdown. The reader also accepts the alternate spellings listed for imported documents.

## Toggles

A toggle is a one-line summary whose blocks open and close on a click. Use one for detail most readers skip: a long log, a derivation, an FAQ answer.

```markdown
<details><summary>How the **rate** is worked out</summary>

Any blocks: paragraphs, lists, tables, code, another toggle.

</details>
```

- `<details open>` starts it open; `<details>` closed. Whether it is open is shared: when someone opens it, it is open for everyone.
- The summary is one line of inline Markdown (bold, italic, code, links), no line breaks or images.
- Separate the body from its tags with blank lines when writing. Imports also accept a summary on the next line and compact blocks without blank lines. An unclosed toggle ends with its surrounding block.
- Exports (PDF, Word) show every toggle open.

## Width of tables, code blocks and data charts

Top-level tables, code blocks and data charts may expand into the margins by default. To keep one within the text column, use `<table data-width-mode="column">` as the opening line of an HTML table, or append `{tickloop-width=column}` to the opening code fence, separated from any language and other information by a space. For a data chart the fence info becomes `chart {tickloop-width=column}`. The choice belongs to that block. A neighboring block can still expand.

## Image width and alignment

An image with no size or alignment stays `![<what it shows>](asset:<id>)`. To set either, write the image as one line:

```markdown
<img src="asset:<id>" alt="Revenue by quarter" width="480" align="center">
```

- `src` as for any image in the doc (an uploaded `asset:<id>`). `alt` and `title` are optional.
- `width` is whole pixels from 1 to 10000; the image never shows wider than the page. `align` is `left` or `center`; without it the image is centred.
- Imports also accept single quotes, a whole-pixel width such as `320px`, and `data-align` for alignment.
- At least one of `width` and `align`. Write `&amp;`, `&quot;`, `&lt;` and `&gt;` for `&`, `"`, `<` and `>` in a value.
- The line stands alone, with blank lines around it.

## Table row height

A row can be given a least height in whole pixels (1 to 10000). A table with one is written in the HTML table form, its row line carrying the height:

```markdown
<table>
<tr height="48">
<th>

Quarter

</th>
</tr>
<tr>
<td>

Q1

</td>
</tr>
</table>
```

Leave heights to people unless the user asks for one; rows grow to fit their content anyway.

## Formulas

Use `$x^2$` for an inline formula. Use double dollar signs when a digit follows the formula.
For a display equation, put `$$` alone on its own line above and below the TeX.
A fenced `math` block can hold multiline TeX verbatim. Code spans and ordinary code fences keep their dollar signs.

## Drawings

Use a fenced `mermaid` block for Mermaid diagrams or a fenced `flow` block for the flowchart.js DSL.
For an existing SVG, use a fenced `svg` block with its SVG namespace and local references. Keep all
pictures and fonts embedded. A drawing's source stays in Markdown; Word embeds the rendered picture.
