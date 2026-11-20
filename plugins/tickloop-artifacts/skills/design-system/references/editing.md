# Working with files

SKILL.md's "The calls" gives the two tools and every `files` value. This page has what follows from them: renames and removals, conflicts, the refusals the service sends, and uploads from clients without `ArtifactUploadAttachment`. Other people and Agents may change the same Design system at the same time, so every change starts from what is there now.

## Reading

- `read` without `path` lists the files with their `binary`, `bytes` and `sha256`, 200 per page (`next_cursor` continues); `read` with `path` returns a file's text with its `sha256`, or an image under `assets/` as an image.
- `read` `tokens.json` again right before every change to it. Never copy a whole `tokens.json` from memory over a newer one; after building, change one token or style at a time with `edits`, keeping every entry you did not mean to change exactly as it was.
- To find where a token name is used, for example every preview that uses `--accent`, read the files under `components/` that can hold it.
- Files under `assets/` are binary uploads: list them, view images with `read`, and reference them by path, but do not read them as text.

## Renames and removals

Each path of a `publish` commits on its own: inspect every result in the receipt.

- **Rename a component**: one `publish` with each of the directory's files copied to the new name as `{"path": "components/Old/…"}`, the files whose links and README mentions you updated, and the old directory as `null`.
- **Remove a component**: publish its directory as `null`.
- `README.md`, `tokens.json` and `tokens.css` cannot be deleted or renamed; change the content of the first two instead. Uploads under `assets/` are removed only by people, on the system's page.

## Conflicts

A publish over someone else's change is refused for that file. Do any read the refusal names, apply your change to the new content keeping everything the other change did, check your other files, and publish once more. Never fall back to overwriting with your older copy. After a second refusal, tell the user and stop. If a publish times out or the connection drops, the outcome is unknown: read the files before trying again.

## When a write is refused

The service refuses a `tokens.json` that breaks a rule in [format](format.md) and changes nothing, and any write or removal of `tokens.css`. Its message starts with `tokens.json:` and names the field the way JavaScript writes it, such as `color.tokens[3].value` or `type.groups[0].styles[1].family`, and the rule it broke; a message with a line and column points at a JSON syntax error, such as a trailing comma. Inspect the message, fix that field, and publish again; never drop tokens just to get a write through.

| Cause | Fix |
| --- | --- |
| A color written as `red`, `var(--x)` or `color-mix(…)` | Write the source's literal value (hex or a color function), or an alias `{token}` of an existing color |
| An alias to a token that does not exist, or to itself | Add the missing token first, or point the alias at the right one |
| A theme-keyed value with an undeclared theme id | Add the theme to `color.themes`, or fix the id |
| A token name used twice across the families | Give one of them a distinct name and update its mentions |
| A text style whose `family` (or its group's) is not a key of `type.families`, or that has none | Add the family stack, or use an existing key |
| A font `file` that is not a path under `assets/` | Point it at the uploaded font (`assets/fonts/…`), or leave `file` out until the upload exists |
| A field the format does not have, or a top-level key without a `tokens` list | Remove it; put descriptions in `usage` notes, a family's `note` or the README |
| A write of `tokens.css` | Change `tokens.json`; the save regenerates the stylesheet |
| `Invalid file path "assets/…": assets/ holds uploaded assets` | Files under `assets/` come only from uploads. Ask the user to attach the image or drop the font on the system's page |
| A system already holding 512 files | Remove a file you no longer need, or ask the user |

## Uploads from other clients

A client without `ArtifactUploadAttachment` sends an image or font's raw bytes over HTTP with the bearer credential of the MCP endpoint, naming its path in the system:

```
POST <service base>/api/v1/artifacts/<artifact_id>/assets?operation_id=<uuid>&path=assets/Logos/mark.svg
Authorization: Bearer <the MCP credential>
Content-Type: image/svg+xml
<raw file bytes>
```

The service base is the MCP endpoint without its final `/mcp`. `Content-Type` is `image/png`, `image/jpeg`, `image/gif`, `image/webp`, `image/svg+xml`, `font/woff2`, `font/woff`, `font/ttf` or `font/otf`; the service checks it against the file's bytes. Use a fresh `operation_id` for each file and reuse it only to retry that file. Uploading needs edit access. Never place the credential in a file, a comment or the chat.
