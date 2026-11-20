# A call that needs an earlier answer

When one call needs another's answer (the latest date in the data, an id), one call may still do it: in SQL a subquery often can, with nothing for a viewer to vary. Where it can't, make each one a dataset: the page's code reads the first and sets the second's filter. A share then covers both, whereas a loader that calls again needs each viewer's own access.

Only what comes from the first answer becomes a `{{name}}`, with a rule, and quoted if it sits in text ("Filters" in [features](features.md)). Whatever must not vary stays written out in `args`:

```
datasets/latest  source: {kind: "call", connector: "cube", tool: "semantic_query", args: {concept: "latest_day"}}
datasets/daily   source: {kind: "call", connector: "cube", tool: "semantic_query",
    args: {concept: "arr", filters: [{member: "day", values: ["{{day}}"]}]},
    rules: {day: {pattern: "^[0-9]{4}-[0-9]{2}-[0-9]{2}$", maxLength: 10}}}
dash/params      {day: "2026-10-28"}
files/index.html
  <section class="lx-daily" hidden>…the marks and drawings of daily…</section>
  <script>
    dash.onData(() => {
      const day = dash.data('latest').data[0]?.day;
      if (day == null) return;
      if (dash.params().day !== day) return dash.setParams({ day });
      for (const el of document.querySelectorAll('.lx-daily')) el.hidden = false;
    });
  </script>
```

It's the rule, not the first answer, that limits what a viewer can ask for: their browser sends the value, and on a shared connector the call runs as the sharer. Sources shows the rule in words when someone shares, but tell the person too what it lets a viewer ask for. A `pattern` rejects a number, so fit the rule to what the first answer actually returns. The default in `dash/params` is the value the first call returned when you ran it.

On a one-writer page a mark under `hidden` loads nothing until it is shown, so the second call waits for its value. A list goes as the whole argument (`values: "{{days}}"`), and its rule holds each item. Compare it as text (`String(a) === String(b)`): `===` on two lists is never true, and `setParams` with equal values does nothing, so the page would wait forever.

On a shared connector, a dataset a loader reads isn't shared: its whole load runs with each viewer's own access, as its further calls do. Sources says so when someone shares; tell the person which query that is. A loader that pages through results can't be made into two datasets. Leave it, and say each viewer runs it with their own access. One that needs no second page stays shared.

An answer that must be asked for and fetched once it is ready (an export, a job) can't be counted on through a share, split or not. Split in two, an ordinary "not ready" answer is the result every reader gets until it is as old as `updates` allows, and by then the first call has usually run again and started another. The rule on its id would also let a viewer fetch any export the sharer can. As one source whose loader calls again, the further calls run as each viewer, so readers without access see nothing. Tell the owner that, and what does work: a tool that answers in one call, or a file that someone brings up to date.
