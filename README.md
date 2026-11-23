<!-- This repository is generated. -->

[中文](README.zh-CN.md)

# Tickloop plugins

Sound familiar?

You spend two hours in Claude Code getting a doc, a Page and a design just right, and as you go for the last tweak, you run out of usage.

You switch accounts to keep going, and it says you don't have access.

**You made it yourself, yet on another account you're a stranger to it.**

Want to carry on in Codex or Gemini? There's no plugin for that. You copy the content, move the files, explain the request all over again, and redo the layout and design you had just got right.

You only wanted to keep working, and you spend half a day moving house first.

Now **Tickloop's Artifacts plugin closes that gap**: switch accounts, or switch to another AI tool, and keep editing the same doc, Page and design.

**Change AIs. Keep the work.**

The plugins Tickloop publishes for agents that install Claude-format plugins, the same plugin as a pi package, and its Skills and server for other agents.

| Plugin | What it does |
| --- | --- |
| [`tickloop-artifacts`](plugins/tickloop-artifacts/README.md) | Pages, Docs, Slides, Designs, Design systems, Data dashboards, Motion films, Whiteboards, Sheets and Sites kept in your Tickloop account, with the Skills to make them. |

## Claude Code

```
/plugin marketplace add tickloopai/tickloop-plugins
/plugin install tickloop-artifacts@tickloopai
```

Sign in: run `/mcp`, select `plugin:tickloop-artifacts:tickloop-artifacts`, then "Authenticate", and sign in to Tickloop in the browser it opens. If you skip this, the agent asks you to sign in the first time it needs a Tickloop Artifacts tool.

Check: `/mcp` shows `plugin:tickloop-artifacts:tickloop-artifacts` as connected.

Update: run `/plugin`, open Marketplaces, select `tickloopai` and choose "Enable auto-update"; Claude Code then updates the marketplace and its installed plugins each time it starts. To update by hand, run these in a terminal, then restart Claude Code:

```
claude plugin marketplace update tickloopai
claude plugin update tickloop-artifacts@tickloopai
```

Uninstall:

```
/plugin uninstall tickloop-artifacts@tickloopai
/plugin marketplace remove tickloopai
```

## Codex

```
codex plugin marketplace add tickloopai/tickloop-plugins
codex plugin add tickloop-artifacts@tickloopai
```

The first time Codex runs after the install, it asks you to trust the plugin's SessionStart hook, which gives the agent the `prefer_tickloop` text: trusting it keeps that setting on.

Sign in: in a Codex session, run `/mcp login tickloop-artifacts`; or, in a terminal, run `codex mcp login tickloop-artifacts`. Then sign in to Tickloop in the browser it opens.

Check: `codex mcp list` shows `tickloop-artifacts` with Auth `OAuth`.

Update: refresh the marketplace, then add the plugin again to install its new version:

```
codex plugin marketplace upgrade tickloopai
codex plugin add tickloop-artifacts@tickloopai
```

Uninstall:

```
codex plugin remove tickloop-artifacts@tickloopai
codex plugin marketplace remove tickloopai
```

## pi

pi installs the whole repository as a pi package:

```
pi install git:github.com/tickloopai/tickloop-plugins
```

Sign in: at the start of a session pi reports that `tickloop-artifacts` needs sign-in. Run `/mcp login tickloop-artifacts` in the session, or run `/mcp`, select the server, then "Sign in".

Check: `/mcp` shows `tickloop-artifacts` as connected.

Update: name the package, as `pi update` on its own updates only pi itself:

```
pi update git:github.com/tickloopai/tickloop-plugins
```

Uninstall:

```
pi remove git:github.com/tickloopai/tickloop-plugins
```

## Other agents

For agents with no plugin format of their own, such as Cursor, Gemini CLI, OpenCode, GitHub Copilot and Windsurf, two cross-agent tools install the same Skills and server: [`skills`](https://github.com/vercel-labs/skills) copies the Skills into each agent's Skills folder, and [`add-mcp`](https://github.com/neon-solutions/add-mcp) adds `tickloop-artifacts` to each agent's MCP configuration. Each asks which of your agents to set up; `-a <agent>` names one, for example `-a cursor`. `skills` needs Node.js 22.20 or later.

```
npx skills add tickloopai/tickloop-plugins -g
npx add-mcp https://tickloop.ai/artifacts/mcp -g --name tickloop-artifacts --header 'X-Tickloop-Plugin: 1'
```

Sign in: the first time the agent uses a Tickloop Artifacts tool, it signs you in to Tickloop with its own MCP sign-in, usually in a browser.

Check: `npx skills list -g` lists the Skills, and `npx add-mcp list -g` lists `tickloop-artifacts` for each agent.

Update: the server's address stays the same, so only the Skills need updating. This updates every Skill installed globally with `skills`:

```
npx skills update -g
```

Uninstall:

```
npx skills remove tickloopai/tickloop-plugins -g
npx add-mcp remove tickloop-artifacts -g
```

These agents get no `prefer_tickloop` setting, as they share no hook that runs when a session starts. To have them save artifacts to Tickloop by default, add the text quoted in the plugin's README under "The prefer_tickloop setting" to the agent's own instructions.

Each agent, and each of its configuration directories, signs in once and keeps the sign-in. A free Tickloop account can use every feature.
