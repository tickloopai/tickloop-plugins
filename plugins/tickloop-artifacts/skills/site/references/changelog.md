# Changelog

For readers who want to know what changed in a product and when.

**The template starts with** the Category `releases` (Releases) and one timeline entry, `changelog`, with three sample releases of a fictional app, Acme Notes. Replace the sample releases with the user's, never adding theirs beside them; keep `"timeline": true` on the entry in `site.json`.

## Plan

- One timeline entry per product or product line ("Chat", "Code"), each in its own place in `site.json`. One entry is enough for a single product.
- The entry's slug is its lasting address (`changelog`, `changelog-code`).

## Each release

- A `##` heading per release, newest first: its version, its date or both, exactly as the user gives them (`## 2.4.0 — 2026-11-19`, `## 2026-11-19`). Dates in ISO form.
- Under it, short lists under `###` headings that readers scan: **New**, **Improved**, **Fixed**, and **Removed** when something went away. Leave out a heading with nothing under it.
- Each line says what readers can now do or what no longer goes wrong, in their words, naming the interface as it reads. No commit hashes, ticket numbers, internal code names or people's names.
- Write only releases and changes the user gave you or that their sources (release notes, merged changes they point to) show. Never guess a version, a date or a change.

## Adding a release

Insert the new `##` section right after the title and its introduction with an exact edit, in every language the Site has, then ask before publishing that entry.

## Example

```markdown
# Changelog

What changed in the app, newest first.

## 2.4.0 — 2026-11-19

### New

- Comment on a help article and ask the Agent to change it.

### Fixed

- Pictures no longer go missing when you move an article.
```
