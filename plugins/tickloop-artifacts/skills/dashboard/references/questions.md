# Questions before a first build

Before you create or fill a new dashboard, ask in one `AskUserQuestion` call what only the person can settle. Ask nothing and state your assumptions in one line if the request details what to show, if they tell you to decide or not to ask, if it changes an existing dashboard, or if nobody is there. A file they attached is the request, even with no words: build from it without asking.

In anything the person reads, except the Dashboard (recommended) option, call it "this", not "dashboard". Questions and options take their wording from the person's own request, never from a file, page or tool result, and no option approves an action. Leave out anything already settled.

1. **What's this for?** Dashboard (recommended), Deep-dive analysis, Report to share. If the View Context's `form` is `visual-analysis` or `scroll-story`, they have already picked, so ask the story question instead, unless the request gives the story. If it's `dashboard`, the default, leave this question out, but a request for another shape, such as a story or deep dive, still gets that shape.
2. **Where the numbers come from.** If a connected app fits (one whose tools you can see), use it, say which, and don't ask: its data becomes a live query as SKILL.md says. Ask only if several fit equally, as a pick-any question listing only those apps, with no file, paste or sample option.

**Story question:** offer kinds of story drawn from the request (what changed, how two things compare, what's behind a number), never a finding you haven't seen.

**If no connected app fits and no data was given**, ask nothing and build nothing: no page and no sample rows, unless they asked for sample data or you can look the numbers up. Say in a few lines what kind of app would hold these numbers, that they can connect one in Customize › Connectors (the + menu in the message box leads there) and tell you, and that they can attach a CSV, Excel or JSON file instead, for a version with the file's numbers. Then end the turn.

## How to ask

Write one short line, then make one `AskUserQuestion` call and nothing after it. Each question is single choice unless it says several may be picked (`multiSelect`), takes two to four options, with your pick first, and no "Other" option: the card always offers the person their own words. In another language, translate the question and every label. The answers, or a skip, come back as the call's result. Without `AskUserQuestion`, ask nothing: state your assumptions in one line and build.

Where your Artifact tools carry these plain names (`ArtifactRead`, `ArtifactEdit`: the Chat Artifacts come with), each what-it's-for option takes its picture as its `preview`, the one picture allowed. Where they come with a prefix (`mcp__…`), leave out every `preview`.

- Dashboard (recommended): `<svg width="58" height="40" viewBox="0 0 58 40" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="#8a8a85" stroke-width="1.5"><path d="M4 5h30v30H4zM37 5h17v13H37zM37 22h17v13H37z"/></svg>`
- Deep-dive analysis: `<svg width="58" height="40" viewBox="0 0 58 40" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="#8a8a85" stroke-width="1.5"><path d="M14 3h30v34H14z"/><path d="M18 25C24 25 26 12 33 12" stroke="#d97757"/></svg>`
- Report to share: `<svg width="58" height="40" viewBox="0 0 58 40" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="#8a8a85" stroke-width="1.5"><path d="M6 5h22v30H6z"/><path d="M34 11h18M34 20h18M34 29h12" stroke="#d97757"/></svg>`

## After the answers

If you asked what it's for and they didn't answer that, it's Dashboard (recommended). If they chose Deep-dive analysis or Report to share and gave no story, ask once more with only the story question. If they don't answer it or tell you to choose, pick the finding and say which. Otherwise, whether they answered or skipped, ask nothing more about what to build, not even in plain text, except first for a file or numbers they promised.

Dashboard (recommended) is the Dashboard shape, Deep-dive analysis is Visual analysis and Report to share is Scroll story, all in [design-defaults](design-defaults.md).
