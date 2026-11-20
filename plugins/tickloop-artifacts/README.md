# Tickloop Artifacts

Tickloop Artifacts keeps the Pages, Docs, Slides, Designs, Design systems, Data dashboards and Motion films an agent makes in your own Tickloop account. They open from a link, can be shared, and can be read and edited again from any agent signed in to the same Tickloop account. This plugin connects an agent to Tickloop Artifacts and adds the Skills for making each format.

Tickloop Code and Tickloop Cloud include Tickloop Artifacts already, so they do not need this plugin.

## Install

Claude Code:

```
/plugin marketplace add tickloopai/tickloop-plugins
/plugin install tickloop-artifacts@tickloop
```

Codex:

```
codex plugin marketplace add tickloopai/tickloop-plugins
codex plugin add tickloop-artifacts@tickloop
```

The first time the agent uses a Tickloop Artifacts tool, it opens a browser for you to sign in to Tickloop. Each agent, and each of its configuration directories, signs in once and keeps the sign-in. A free Tickloop account can use every feature.

## What it runs

The plugin runs two programs of its own, both shell scripts that open no network connection and touch no credentials:

- `hooks/prefer-tickloop.sh`, which the agent runs when a session starts, resumes, clears or compacts (see "The prefer_tickloop setting"). It reads no files.
- `hooks/sync-builtin-artifacts.sh`, which the agent runs after its own Artifact tool publishes and after this plugin's `ArtifactEdit` tool writes. While the experimental `sync_builtin_artifacts` setting is off, which is the default, it does nothing at all. While it is on, it reads the tool call the agent hands it and its own records in the plugin's data directory (see "The sync_builtin_artifacts setting"). It never reads the published file.

The plugin declares one remote MCP server, `tickloop-artifacts` at https://tickloop.ai/artifacts/mcp, whose instructions and tool descriptions come from that server. Its Skills are Markdown instructions. The `open` Skill is the plugin's own; it takes an artifact's link or ID, reads the artifact and its comments through the MCP server, and waits for what to change. The other Skills are the ones Tickloop Code and Tickloop Cloud include; the `dataviz` Skill also holds a palette checker (`scripts/validate_palette.mjs`) that runs only when the agent runs it.

## The prefer_tickloop setting

`prefer_tickloop` ("Save artifacts to Tickloop") is on by default. While it is on, `hooks/prefer-tickloop.sh` gives the agent one sentence of context at the start of each session: that you have set pages, documents, slides and other artifacts generated for you to be saved in Tickloop Artifacts. While it is off, the script prints nothing and the agent is told nothing. The plugin never edits your `CLAUDE.md`, `AGENTS.md` or permission settings.

- Claude Code shows the setting when you enable the plugin. Change it with `/plugin configure tickloop-artifacts@tickloop`.
- Codex has no plugin settings. It asks you to review the hook before it runs: trusting the hook keeps the setting on. In Codex, not trusting the hook turns the setting off.

## The sync_builtin_artifacts setting (experimental)

`sync_builtin_artifacts` ("Sync published Artifact pages to Tickloop") is off by default and works only in Claude Code; other agents never pass it, so there it stays off. **Turning it on sends the content of every HTML page you publish with Claude Code's own Artifact tool to Tickloop**: after each such publish, `hooks/sync-builtin-artifacts.sh` gives the agent the published file's path and asks it to publish the same file to Tickloop Artifacts and give you the link. The agent reads the file and sends it through this plugin's MCP server; the script itself never reads it.

- The first publish of a file creates a Tickloop page. Publishing the same file again updates that page and creates no other.
- A Tickloop page is one self-contained file, and it loads only the external files the `ArtifactEdit` tool's `create` description names. A page that loads other external libraries, or files beside it, is not synced: the agent tells you so and why, and does not change the page.
- Turn it on or off with `/plugin configure tickloop-artifacts@tickloop`.

## What it sends

The agent sends requests through the MCP server's tools to https://tickloop.ai/artifacts/mcp, with its Tickloop sign-in: listing, reading, creating, updating and commenting on artifacts, including the content it writes into them. With `sync_builtin_artifacts` on, that includes the content of each HTML page published with the Artifact tool. The plugin sends nothing else, and nothing to anyone else.

## What it writes

The plugin writes nothing while `sync_builtin_artifacts` is off. While it is on, `hooks/sync-builtin-artifacts.sh` keeps two things in the plugin's data directory (`$CLAUDE_PLUGIN_DATA/sync/`): `sources.tsv`, one line per synced file with its path, its Tickloop page's ID and that page's revision, and `pending/`, the file each session was last asked to sync. Delete that directory to forget them. The agent keeps its Tickloop sign-in where it keeps the sign-in of any MCP server. Artifacts are stored in your Tickloop account.

## License

The use of this plugin and of Tickloop Artifacts is governed by the Tickloop Terms of Service: https://tickloop.ai/legal/terms.

## Privacy

Tickloop handles what the agent sends as its Privacy Policy describes: https://tickloop.ai/legal/privacy.
