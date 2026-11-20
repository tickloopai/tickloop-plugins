# Rendering offline — stills without opening the film

Stills are for checking, and only when the user asks for them. A video file comes only from Export, on the film's page.

The Motion player draws every frame from the film's documents, in the person's browser. It hands no headless entry to
your tools: there is no runner you can download, no `#tools` page and no driver to call, and a Chromium you install or a
screenshot of the service's pages is no stand-in (never install a browser or other tools for it, and never search the
environment for credentials).

So a still can't be made here. Say so in a sentence, and ask the user to scrub the film on its page to the moment in
question. Then go on with what they asked, from the documents, which you read whole.

## Honest limits

- The stage loads nothing from outside: every image, font and clip is one of the film's `assets`
  (fonts as .woff2/.woff/.ttf/.otf, registered by file stem); text set in
  a face that is not an asset or a family in `scenes.json`'s `fonts` renders in whatever the viewer's machine has.
- A Google family named in `fonts` is fetched by the player; where it can't be, a frame shows its `or` (words that the ten
  shipped faces, rough-cut.md, can't spell: the machine's face). later.md's "What to say about fonts" says what to tell them.

The film folder that the documents mirror is in [film-folder.md](film-folder.md).
