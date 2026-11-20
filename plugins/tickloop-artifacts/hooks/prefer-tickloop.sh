#!/bin/sh
# Runs when a session starts. Unless the prefer_tickloop setting is off, it tells the agent where the user has set
# artifacts to be saved. Only Claude Code passes the saved setting, as CLAUDE_PLUGIN_OPTION_PREFER_TICKLOOP; on every
# other host the setting keeps its default, on. It reads no files, opens no connection and touches no credentials.
[ "${CLAUDE_PLUGIN_OPTION_PREFER_TICKLOOP:-true}" = false ] && exit 0
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"The user has set pages, documents, slides and other artifacts generated for them to be saved in Tickloop Artifacts."}}'
