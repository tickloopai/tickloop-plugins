> Generated automatically from Tickloop's source repository. Do not edit it here: submit changes to the source repository.

# Tickloop plugins

The plugins Tickloop publishes for agents that install Claude-format plugins, the same plugin as a pi package, and its Skills and server for other agents.

| Plugin | What it does |
| --- | --- |
| [`tickloop-artifacts`](plugins/tickloop-artifacts/README.md) | Pages, Docs, Slides, Designs, Design systems, Data dashboards and Motion films kept in your Tickloop account, with the Skills to make them. |

## Claude Code

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

## Codex

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

## pi

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

## Other agents

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
