# Product docs

For people who build with or run a product: how to set it up, use each part, configure it and look up exact details.

**The template starts with** sample docs for a fictional developer tool, Acme CLI: Categories `getting-started` (Getting started), `guides` (Guides) with the Subcategory `configuration` (Configuration), and `reference` (Reference), and the entries `introduction`, `quickstart`, `concepts`, `import-markdown`, `scheduled-backups`, `settings`, `cli-reference` and `glossary`. Replace the samples with the user's entries (see "Sample entries" in the Skill).

## Plan

1. **Getting started**: an introduction (what it is, who it is for, what you need) and a quickstart: the shortest path to a first working result.
2. **Guides**: one how-to or concept entry per task or part of the product, grouped into Subcategories when there are many ("Configuration", "Integrations", "Deployment").
3. **Reference**: exact, complete facts readers look up: settings, commands, API fields, limits, errors, a glossary. Tables suit them.
4. Order guides as a reader meets the product: install, configure, everyday use, advanced, operating it.

## Entries

- Take every command, setting name, default, limit and error text from the product's source or documents the user points to, exactly; never write one from memory or by analogy.
- Code blocks name their language (`` ```bash ``, `` ```json ``) and hold commands that run as written; say what each placeholder stands for.
- A reference table gives every item, not a sample: name, what it does, type or values, default.
- Link guides to the reference entries that list their details, by slug, and back.

## Example

````markdown
# Settings

Every setting, what it changes and its default.

| Setting | What it does | Default |
| --- | --- | --- |
| `timeout` | Seconds a request waits before it fails. | `30` |
| `retries` | How often a failed request is sent again. | `2` |

Change a setting in `config.json`:

```json
{ "timeout": 60 }
```
````
