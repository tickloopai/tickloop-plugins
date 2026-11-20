# Writing a good deck — the long form

The Slides Skill has the checklist. This page explains the reasons behind it. Read it if the user argues with a design choice, asks for a kind of deck the checklist does not cover (like a keynote or a training deck), or asks for speaker notes. The content rules every Artifact follows are at the end of this page.

## Writing a good deck

There is no house look. The fonts are the ones you put in `project/deck.json` `faces` ([fonts](fonts.md)); the palette is the hex colors you choose for the brief, or a chosen design system's.

- **One idea per Slide.** One big statement Slide is better than three bullet-point-ish Slides. Several short Slides beat one crowded Slide.
- **128px edge margins** are the standard: `padding: 128px 128px 160px` on every section, the bottom margin leaving room for the footer band. Pinned elements start 128px from an edge, unless you have a reason to do something else.
- **Respect your type scale.** Choose four or five font sizes and use them again and again. Use eyebrows (24–28px, all caps, extra letter spacing, accent color) for labels. Use headings to make statements. Use 40–48px for agenda-level points and 28–36px for sentences. Never use less than 24px.
- **Change backgrounds on purpose.** Use the palette's dark color for the opening and closing Slides and the light color for the main content. Use the accent color for one statement Slide: the single number or sentence you want people to remember. Always set `background` on every section.
- **Width discipline.** Flow text inside the margins is 1664px wide, too wide for body text. Put sentences in a column 800–1200px wide (`width: 960px`, or a `flex: 1` column next to something else). Display lines work best at about 1400px wide. The other limit is the longest word: count characters before you choose how many columns to use.
- **Vertical space budget.** The Slide is 1080px tall and nothing scrolls. Inside the margins you have 792px of height; the [layout reference](layout.md) has the table. A two-line heading at 96px with line height 1.1 ≈ 210px; a gap, 48px; each table row ≈ 2.1 × the font size per line of text in its tallest cell (one row at 32px ≈ 67px), so 9 rows ≈ 600px do not fit under that heading. A card body = lines × font size × line height + padding. Never set a fixed `height` on a text box smaller than this total; leave the height out. If the content is too tall, split the Slide.
- Keep decks under about 50 Slides. Each Slide is one file; a deck's size is mainly its images. Reuse one uploaded image instead of uploading several crops.

## You are a presentation designer

Think like a consultant or executive preparing boardroom material: clarity, narrative flow and back-of-the-room readability. The format is deliberately not the web. Each Slide is a fixed 1920×1080 page, designed like a poster, and makes sense on its own.

Only ask what you cannot figure out on your own (how long the deck should be, and who it is for, when the request gives no hint). A topic and an occasion are enough to start a draft. Ask what the material leaves open, in its own terms: which thread leads and what gets cut, what the room should do after it (decide, approve, just know). Default what the setting implies ("staff meeting" → their leads, about 8 Slides), and say so. A missing number is a `[__]` placeholder, not a question. Ask at most one short message of questions, and only when a person is there to answer; otherwise decide, build and state your assumptions in one line.

When the user gives a font size, it is in **points**: `px = pt × 2` (so "36pt" = 72px).

## Outline and titles first

Write the outline first: the Slide titles alone should tell the story, like a table of contents. The outline's sections, one sentence each, go into `sections` in `project/deck.json`.

Write the full title sequence before any Slides, in ONE grammatical style:

- short topic titles ("Market Research", "Engagement Overview", "Team Structure"), or
- action titles, short statements of the point ("Asia is our largest market…", "…but Eastern Europe has the highest potential for growth").

Read just the titles: a person should understand the flow from them alone. Share the outline in chat as a list of the titles before or while you make the Slides; do not wait for approval unless the request was unclear.

Avoid titles that sound machine-written: titles that "deliver the verdict", that are too dramatic, that create fake tension ("It's not X. It's Y."), heavy reframing, faux-insight titles ("The magic moment"). A title INTRODUCES the Slide; it is not the speaker's punchline.

## Less text, more structure

Avoid putting too much text on Slides. Decide which parts should be tables, diagrams, quotes, images, card rows or big numbers. Mix the look: full-image Slides, different backgrounds, big numbers, quotes, tables, and some text. Avoid Slides that are a short block of text hanging under the heading with nothing below: spread the body down the Slide (below), don't center the column.

Use parallel design: section openers look the same; elements that repeat sit in the same place, the heading at the same height on every content Slide; Slides of the same kind use the same markup (padding, gap, sizes).

## Commit to the system up front

Say the system you will use: a layout for each kind of Slide (cover, section opener, content, image, statement), with variety and rhythm on purpose. On Slides with a lot of text, commit to the user's imagery or to structure (a table, a card row, a big number). Do not use web density (14–16px body text): the smallest text is 24px, and if the text only fits at 20px, there is too much text.

## Speaker notes (`<aside>`)

Add speaker notes when the user asks for a talk, a script or 讲稿, or someone else will present. Then the deck becomes visual-first and the notes carry the script: write them like a conversation, the full words the presenter will say out loud, not bullet points. Put one `<aside>` last in each section. Because the notes carry the story, take text off the Slides: large figures, quotes, full-bleed images, diagrams and one-line headlines instead of paragraphs. If a Slide has a lot of text, the script is on the Slide; move it to the notes.

## Compose like a Slide designer, not a web designer

There is no review pass after saving, so decide each Slide's composition as you write it. A statement or title Slide with open space below is correct. A CONTENT Slide whose column stops at 60% of the height reads as unfinished. Spread the column on purpose:

- Fill the whole height: `justify-content: space-between`, or a `flex: 1` spacer before the last row. The heading stays at the top margin, at the same height as on the deck's other content Slides, so it does not hop when the viewer flips through them.
- Center the content only on a Slide with no heading above its body (a statement, a quote) with `justify-content: center`. Never center a column with a heading above its body: the column's height then sets where the heading lands, differently on every Slide.

Plan the `gap` so the blocks span the 792px.

## Content rules every Artifact follows

- **Do not add filler content.** Never pad a deck with placeholder text, dummy sections or informational material just to fill space. Every element earns its place. If a Slide feels empty, solve it with layout and composition, not by inventing content. Avoid unnecessary numbers, icons or stats; less is more.
- **Ask before adding material.** If you think more Slides, sections or copy would help, ask the user first rather than adding them unasked. The user knows their audience and goals better than you do.
- **Targeted changes stay targeted.** When the user asks for a small change — some text, a color, one element — change ONLY that: leave all other layout, spacing, fonts, sizes, positions, colors and content exactly as they are. A redesign or a from-scratch request is different. If you think a broader change would help a small request, finish what they asked and SUGGEST the rest.
- **Follow an existing deck's visual vocabulary.** When adding to a deck, learn its system first — fonts, palette, layouts, footer, heading position, density — and follow it.
- **Avoid generated-looking tropes:** aggressive gradient backgrounds, emoji (unless the brand or design system uses them), and cards with rounded corners and a left-border accent color.
- **Build from source, not from memory.** When asked to match a brand or a design whose source you can reach — a chosen design system, a pasted file — read the real source and copy its exact values rather than rounding them or recalling them from memory.
- **Do not recreate copyrighted designs.** If asked to recreate a company's distinctive branded visual elements, ask whether the user works there and is entitled to them; otherwise help them make an original design.
