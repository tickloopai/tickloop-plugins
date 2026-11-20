#!/bin/sh
# This repository is generated.
# Runs when a session starts. Unless the prefer_tickloop setting is off, it tells the agent where the user has set
# artifacts to be saved, and how the user signs in to Tickloop in this host when the Tickloop Artifacts tools need it.
# Only Claude Code passes the saved setting, as CLAUDE_PLUGIN_OPTION_PREFER_TICKLOOP; on every other host the setting
# keeps its default, on. Codex sets PLUGIN_ROOT beside CLAUDE_PLUGIN_ROOT and Claude Code sets only CLAUDE_PLUGIN_ROOT;
# a host that sets neither gets both hosts' commands. It reads no files, opens no connection and touches no credentials.
[ "${CLAUDE_PLUGIN_OPTION_PREFER_TICKLOOP:-true}" = false ] && exit 0
if [ -n "${PLUGIN_ROOT:-}" ]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"The user has set pages, documents, slides and other artifacts generated for them to be saved in Tickloop Artifacts. When the Tickloop Artifacts tools are missing or need sign-in, the user wants to be asked first to sign in to Tickloop through the tickloop-artifacts MCP server, with nothing saved elsewhere until then. In Codex, the user signs in by running /mcp login tickloop-artifacts in the session, or codex mcp login tickloop-artifacts in a terminal."}}'
elif [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"The user has set pages, documents, slides and other artifacts generated for them to be saved in Tickloop Artifacts. When the Tickloop Artifacts tools are missing or need sign-in, the user wants to be asked first to sign in to Tickloop through the tickloop-artifacts MCP server, with nothing saved elsewhere until then. In Claude Code, the user signs in by running /mcp, selecting plugin:tickloop-artifacts:tickloop-artifacts, then Authenticate."}}'
else
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"The user has set pages, documents, slides and other artifacts generated for them to be saved in Tickloop Artifacts. When the Tickloop Artifacts tools are missing or need sign-in, the user wants to be asked first to sign in to Tickloop through the tickloop-artifacts MCP server, with nothing saved elsewhere until then. In Claude Code, the user signs in by running /mcp, selecting plugin:tickloop-artifacts:tickloop-artifacts, then Authenticate. In Codex, the user signs in by running /mcp login tickloop-artifacts in the session, or codex mcp login tickloop-artifacts in a terminal."}}'
fi
