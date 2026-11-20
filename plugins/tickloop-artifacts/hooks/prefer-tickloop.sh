#!/bin/sh
# Runs when a session starts. Unless the prefer_tickloop setting is off, it tells the agent where the user has set
# artifacts to be saved, and that the user wants to be asked to sign in when the Tickloop Artifacts tools need it.
# Only Claude Code passes the saved setting, as CLAUDE_PLUGIN_OPTION_PREFER_TICKLOOP; on every other host the setting
# keeps its default, on. It reads no files, opens no connection and touches no credentials.
[ "${CLAUDE_PLUGIN_OPTION_PREFER_TICKLOOP:-true}" = false ] && exit 0
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"The user has set pages, documents, slides and other artifacts generated for them to be saved in Tickloop Artifacts. When the Tickloop Artifacts tools are missing or need sign-in, the user wants to be asked first to sign in to Tickloop through the tickloop-artifacts MCP server, with nothing saved elsewhere until then."}}'
