# Callouts in a doc

A callout sets a few blocks apart under a kind, the way GitHub's alerts do: a quote whose first line is the kind alone, in capitals, then a blank quote line, then the blocks, each line behind `> `.

```markdown
> [!WARNING]
>
> Rates reset on 1 March. Check the new figures before you quote them.
>
> - Fixed loans keep their rate.
> - Variable loans move with the base rate.
```

The editor, the share view and every export (HTML, PDF, Word) show it as a tinted panel with the kind's icon and name.

## Kinds

| kind | for |
|---|---|
| `[!NOTE]` | background a reader should have while reading on |
| `[!TIP]` | a better way to do what the text describes |
| `[!IMPORTANT]` | what a reader must know to succeed |
| `[!WARNING]` | a risk that needs attention now |
| `[!CAUTION]` | what goes wrong, or cannot be undone, if done |

Pick the kind by what the reader should do with it, not by how loud it looks. A callout earns its place by being rare: one or two in a doc, around the passage they qualify; a page of callouts reads as no emphasis at all, and a whole section in one belongs in the section itself.

## What it holds

- Any blocks: paragraphs, lists, task lists, tables, code blocks, quotes, charts, diagrams, another callout. A heading inside one is never needed; the kind is its title.
- The kind line holds nothing but `[!KIND]`: `> [!NOTE] Text` is an ordinary quote that starts with those words.
- Every line of the callout starts with `>`; an empty line ends it. A line without `>` right after a paragraph line continues that paragraph, so write the `>` on every line rather than rely on it.
- An ordinary quote whose first words are `[!NOTE]` is written `> \[!NOTE]`, so it stays a quote.
