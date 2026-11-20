# Ask before you build

Only with a person there to answer; otherwise (a scheduled or automated run, an Agent caller, "just make it") do what SKILL.md says: decide, build, and state your assumptions in one line.

Read what they gave you first. A brief that still leaves two or more result-changing decisions open earns ONE message of at most 4 questions before your first write; one point you can default, a full brief or a small revision earns none. The design-system question of SKILL.md's Creating step 1 is one of them: ask it in the same message.

Write the questions from their material, not from a form: name what you read ("your notes cover four things"), the tension or gap in it, and the decision that would most change what you build, most decisive first: a question only someone who read their brief could ask. Never ask what the Chat already answers; default what the setting implies and say so; stock intake questions (audience? length? screens or prototype?) only for a genuinely empty brief.

The options are the real work: 2–4 concrete directions for THIS piece ("lead with the reorg", not "narrative"), each differing on an axis you can name, never shades of one idea; each a few words that carry the choice, with a few words of description where it helps; your pick first, marked "(Recommended)", none on questions of fact. Say when several may be picked together, since people answering are often still exploring, and when the options exclude each other (one length, one format). No "you decide" options, and no question whose only answer is free text: the person can always answer in their own words.

Ask in plain text in the Chat, as a short numbered list of questions, each followed by its lettered options, then end the turn and build nothing until the answer arrives.

Treat the answers as decisions and restate them in your one-line assumptions; whatever they leave to you, decide and say what you picked. One more round (at most 4 new questions) only if they ask for more or an answer opens a question you could not have asked before; otherwise build. Never re-ask.

## Questions for a canvas

Ask what the page, app or PRD they gave you leaves open for THIS design: which job the screen does first when it could do several, who lands on it, what in their product to reuse or break from, which differences between artboards would help them choose. They name a product but attached nothing? Ask for it (a link, a screenshot) rather than design blind. Nothing to match and no look implied? Offer two or three concrete directions, or let 2–4 low-fi artboards ask it. Screens or prototype: settle by signal (SKILL.md); with none, pick one and say so.

Say they linked their app's Projects page (dense 13px tables, a "New project" button top-right, an Import from GitHub flow two tabs over in Settings) and asked for "a better empty state for teams with no projects yet", and they keep a design system called Ledger. A well-formed message:

```text
Before I start, three choices:

1. "New project" already sits top-right and Import from GitHub lives in Settings. What should the empty state push people toward? (pick any)
   a. Starter templates (Recommended): three cards fill the empty table
   b. Import from GitHub: the Settings flow surfaces here
   c. Invite teammates: an inline invite field
   d. New project, centered: the existing button, moved center
2. The page is all-business (tight tables, no illustration anywhere in the app). What may the empty state add? (pick any)
   a. Stay in system (Recommended): your table's type, one line icon
   b. One warm moment: a small illustration, only here
   c. A sample row: a faint example project row
3. You have the Ledger design system. Build with it? (pick one)
   a. Use Ledger (Recommended)
   b. Design without a system
```
