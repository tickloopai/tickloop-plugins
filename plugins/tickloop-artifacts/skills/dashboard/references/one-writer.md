# A page with one writer for each part

Every new page's `index.html` opens with `<meta name="dash-one-writer">` and is written to this rule, so each part of the page has one writer. Text you know as you write, labels of tabs, columns and series too, is in the HTML, and no script writes it. Your code draws what the data decides, in elements stored empty. The rule is about who writes what, not what a page may be: a scroll story, an animation or any control fits. This file holds wherever another says otherwise, samples included. A page stored without the line is older, and of what follows only the last section applies to it.

Outside a drawing a script only listens and sets `class`, `style`, `hidden`, `open`, `disabled`, `checked`, `selected`, `value`, `tabindex` or `aria-*`. Any other write there is a fault. A person may delete or move any element. So a script finds what it needs with `querySelectorAll` and a loop, and still works when it finds none.

## Drawings

What the data decides (a number, a word, a chart, a `<tbody>`, a `<select>`'s choices) is an element marked `data-draw="name"`, stored with at most a `—` in it. A table or part of one, a list or a `<select>` is stored empty, since a browser moves a dash out of a table. A drawing inside another is never called. A drawing is only what changes, a word and not its sentence:

```
<p>Sales met the <b data-draw="goal">—</b> goal in <b data-draw="met" data-source="weeks" data-field="met">—</b> weeks.</p>
```

When data picks between whole sentences, each is in the HTML. An empty drawing beside them sets `hidden` on the rest.

`dash.draw(name, fn)` runs `fn(el)` on each `data-draw="name"` after the scripts, and whenever data, a filter, the page's width or `el`'s own width changes. `el` still holds what the last call left. So `fn` replaces or d3-joins its contents, including the `—`, so that two calls leave one chart, and puts the `—` back when a status isn't `"ok"`. Inside a drawing your code may write from a handler, a timer or a frame. `dash.draw(name)` reruns the drawing, say after a sort.

Put what's set up once, like a listener, timer or animation, in `dash.draw(name, {mount, update, unmount})`. `mount(el)` gets the emptied element, and runs again after a throw. `update(el, made)` runs at each call with what `mount` returned. `unmount(el, made)` runs when the element leaves or a call throws.

A tooltip is inside its chart's drawing: one with its own drawing would be redrawn, and put away, as it is shown. A fixed reference the person chose, a goal or a limit, is one unmarked constant in a script, drawn wherever it shows, a note's "over 4 hours" too, so words and arithmetic can't drift.

A control is in the HTML, and one whose choices come from data is a drawing:

```
<select class="dash-select" data-draw="region" aria-label="Region" data-source="regions"></select>
<script>
  dash.draw('region', (sel) => {
    const g = dash.data('regions');
    sel.replaceChildren(new Option('All regions', ''), ...(g.status === 'ok' ? g.data : []).map((r) => new Option(r.region)));
    sel.value = dash.params().region ?? '';
    sel.onchange = () => dash.setParams({region: sel.value || null});
  });
</script>
```

## Hidden

Under the `hidden` attribute, not a class, nothing marked loads and no drawing runs until it comes off. So a drawing can't show itself or its container. `dash.onData(fn)` runs before the drawings and can. Another HTML file can't be linked to, so several pages, tabs too, are `<section>`s of `index.html`, with all but the open one `hidden`. Opening a page also calls `dash.setLink` with its `id` ("Links" in [design-defaults](design-defaults.md)). `dash.data` outside a drawing loads at once, so a page's data is read inside its drawings.

## Later changes

A person may have saved changes since you read a file, so read it again before each change, or an older copy would undo them. Keep the `<meta name="dash-one-writer">` line where it is, and never add it to an older page alone: all that its scripts write would then be a fault. A page without it keeps its own way of writing unless the person asks for it to be rewritten, and then every file is written to this rule, with the line first in `index.html`, the datasets and `dash/params` left alone, and all a reader sees kept as it was.
