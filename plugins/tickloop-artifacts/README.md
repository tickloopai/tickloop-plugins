# Tickloop Artifacts

Tickloop Artifacts keeps the Pages, Docs, Slides, Designs, Design systems, Data dashboards and Motion films an agent makes in your own Tickloop account. They open from a link, can be shared, and can be read and edited again from any agent signed in to the same Tickloop account. This plugin connects an agent to Tickloop Artifacts and adds the Skills for making each format.

Tickloop Code and Tickloop Cloud include Tickloop Artifacts already, so they do not need this plugin.

## Install

### Claude Code

```
/plugin marketplace add tickloopai/tickloop-plugins
/plugin install tickloop-artifacts@tickloop
```

Sign in: the first time the agent uses a Tickloop Artifacts tool, it opens a browser for you to sign in to Tickloop. To sign in before that, run `/mcp`, select `plugin:tickloop-artifacts:tickloop-artifacts`, then "Authenticate".

Check: `/mcp` shows `plugin:tickloop-artifacts:tickloop-artifacts` as connected.

Uninstall:

```
/plugin uninstall tickloop-artifacts@tickloop
/plugin marketplace remove tickloop
```

### Codex

```
codex plugin marketplace add tickloopai/tickloop-plugins
codex plugin add tickloop-artifacts@tickloop
```

The first time Codex runs after the install, it asks you to trust the plugin's SessionStart hook, which gives the agent the `prefer_tickloop` sentence: trusting it keeps that setting on.

Sign in: run `codex mcp login tickloop-artifacts` and sign in to Tickloop in the browser it opens.

Check: `codex mcp list` shows `tickloop-artifacts` with Auth `OAuth`.

Uninstall:

```
codex plugin remove tickloop-artifacts@tickloop
codex plugin marketplace remove tickloop
```

### pi

pi installs the whole repository as a pi package:

```
pi install git:github.com/tickloopai/tickloop-plugins
```

Sign in: at the start of a session pi reports that `tickloop-artifacts` needs sign-in. Run `/mcp login tickloop-artifacts` in the session, or run `/mcp`, select the server, then "Sign in".

Check: `/mcp` shows `tickloop-artifacts` as connected.

Uninstall:

```
pi remove git:github.com/tickloopai/tickloop-plugins
```

### Other agents

For agents with no plugin format of their own, such as Cursor, Gemini CLI, OpenCode, GitHub Copilot and Windsurf, two cross-agent tools install the same Skills and server: [`skills`](https://github.com/vercel-labs/skills) copies the Skills into each agent's Skills folder, and [`add-mcp`](https://github.com/neon-solutions/add-mcp) adds `tickloop-artifacts` to each agent's MCP configuration. Each asks which of your agents to set up; `-a <agent>` names one, for example `-a cursor`. `skills` needs Node.js 22.20 or later.

```
npx skills add tickloopai/tickloop-plugins -g
npx add-mcp https://tickloop.ai/artifacts/mcp -g --name tickloop-artifacts --header 'X-Tickloop-Plugin: 1'
```

Sign in: the first time the agent uses a Tickloop Artifacts tool, it signs you in to Tickloop with its own MCP sign-in, usually in a browser.

Check: `npx skills list -g` lists the Skills, and `npx add-mcp list -g` lists `tickloop-artifacts` for each agent.

Uninstall:

```
npx skills remove tickloopai/tickloop-plugins -g
npx add-mcp remove tickloop-artifacts -g
```

These agents get no `prefer_tickloop` setting, as they share no hook that runs when a session starts. To have them save artifacts to Tickloop by default, add the sentence quoted in the plugin's README under "The prefer_tickloop setting" to the agent's own instructions.

Each agent, and each of its configuration directories, signs in once and keeps the sign-in. A free Tickloop account can use every feature.

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
