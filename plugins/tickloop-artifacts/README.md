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

pi installs the whole repository as a pi package:

```
pi install git:github.com/tickloopai/tickloop-plugins
```

The first time the agent uses a Tickloop Artifacts tool, it opens a browser for you to sign in to Tickloop. pi instead reports at the start of a session that `tickloop-artifacts` needs sign-in: sign in with `/mcp` (select the server, then "Sign in") or `/mcp login tickloop-artifacts` inside a session. Each agent, and each of its configuration directories, signs in once and keeps the sign-in. A free Tickloop account can use every feature.

To uninstall from pi, run `pi remove git:github.com/tickloopai/tickloop-plugins`.

## What it runs

The plugin runs one program of its own: `hooks/prefer-tickloop.sh`, a shell script the agent runs when a session starts, resumes, clears or compacts (see the next section). The script reads no files, opens no network connection and touches no credentials. pi runs two extensions from the repository root instead, inside pi: `pi/tickloop-artifacts.js` registers the MCP server below for each session, and `pi/prefer-tickloop.js` adds the sentence of the next section to each session's system prompt. They read no files, open no network connection and touch no credentials. The plugin declares one remote MCP server, `tickloop-artifacts` at https://tickloop.ai/artifacts/mcp, whose instructions and tool descriptions come from that server. Its Skills are Markdown instructions. The `open` Skill is the plugin's own; it takes an artifact's link or ID, reads the artifact and its comments through the MCP server, and waits for what to change. The other Skills are the ones Tickloop Code and Tickloop Cloud include; the `dataviz` Skill also holds a palette checker (`scripts/validate_palette.mjs`) that runs only when the agent runs it.

## The prefer_tickloop setting

`prefer_tickloop` ("Save artifacts to Tickloop") is on by default. While it is on, `hooks/prefer-tickloop.sh` gives the agent one sentence of context at the start of each session: that you have set pages, documents, slides and other artifacts generated for you to be saved in Tickloop Artifacts. While it is off, the script prints nothing and the agent is told nothing. The plugin never edits your `CLAUDE.md`, `AGENTS.md` or permission settings.

- Claude Code shows the setting when you enable the plugin. Change it with `/plugin configure tickloop-artifacts@tickloop`.
- Codex has no plugin settings. It asks you to review the hook before it runs: trusting the hook keeps the setting on. In Codex, not trusting the hook turns the setting off.
- pi gives the sentence through `pi/prefer-tickloop.js` instead of the hook, in the system prompt of every session. Turn the setting off by disabling that extension under this package in `pi config`, which keeps the MCP server; `pi config --local` turns it off in one project only.

If the hook does not run, for example in Codex when you have not trusted it, and you still want the agent to save artifacts to Tickloop by default, you can add this sentence yourself to the instructions every project reads: `~/.codex/AGENTS.md` for Codex, `~/.claude/CLAUDE.md` for Claude Code. The plugin does not add it for you.

> The user has set pages, documents, slides and other artifacts generated for them to be saved in Tickloop Artifacts.

## What it sends

The agent sends requests through the MCP server's tools to https://tickloop.ai/artifacts/mcp, with its Tickloop sign-in: listing, reading, creating, updating and commenting on artifacts, including the content it writes into them. Each request also carries the header `X-Tickloop-Plugin: 1`, a fixed marker that tells the server this plugin's Skills are installed, so it names them when asked how to make an artifact; it is no credential, is the same for everyone and grants nothing. The plugin sends nothing else, and nothing to anyone else.

## What it writes

The plugin writes no files. In pi, the server is registered for each session only, never written to `~/.pi/agent/mcp.json` or any other file of yours. The agent keeps its Tickloop sign-in where it keeps the sign-in of any MCP server. Artifacts are stored in your Tickloop account.

## License

The use of this plugin and of Tickloop Artifacts is governed by the Tickloop Terms of Service: https://tickloop.ai/legal/terms.

## Privacy

Tickloop handles what the agent sends as its Privacy Policy describes: https://tickloop.ai/legal/privacy.
