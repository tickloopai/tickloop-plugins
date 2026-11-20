#!/bin/sh
# Runs after the Artifact tool publishes and after this plugin's ArtifactEdit tool writes, while the
# sync_builtin_artifacts setting is on. Only Claude Code passes the saved setting, as
# CLAUDE_PLUGIN_OPTION_SYNC_BUILTIN_ARTIFACTS; on every other host it keeps its default, off, and this does nothing.
# After an HTML file is published it tells the agent to publish the same file to Tickloop Artifacts. After a Tickloop
# create or replace it records in the plugin data directory which Tickloop page each published file went to, and its
# revision, so the next publish of that file updates that page. It reads only its standard input and its own data
# files, opens no connection and touches no credentials.
# shellcheck disable=SC2016 # the awk programs are single-quoted on purpose
[ "${CLAUDE_PLUGIN_OPTION_SYNC_BUILTIN_ARTIFACTS:-false}" = true ] || exit 0
[ -n "${CLAUDE_PLUGIN_DATA:-}" ] || exit 0

TICKLOOP_EDIT_TOOL=mcp__plugin_tickloop-artifacts_tickloop-artifacts__ArtifactEdit
state="$CLAUDE_PLUGIN_DATA/sync"
# One line per published file: the file's path as JSON string text, its Tickloop page's id and that page's revision.
sources="$state/sources.tsv"

# The hook input is one line of JSON: the fields before tool_input, tool_input, then tool_response. A key is read only
# where it follows `{` or `,` outside a string, which a string's escaped quotes never do.
input=$(tr -d '\n\r')
head=${input%%,\"tool_input\"*}
tool_input=$(printf '%s' "$input" | sed -E 's/.*[{,][[:space:]]*"tool_input"[[:space:]]*:[[:space:]]*//; s/,[[:space:]]*"tool_response"[[:space:]]*:.*//')
tool_response=$(printf '%s' "$input" | sed -nE 's/.*[{,][[:space:]]*"tool_response"[[:space:]]*:(.*)/\1/p')

# A string field's text, still JSON-escaped.
string_field() {
  printf '%s' "$1" | sed -nE 's/.*[{,][[:space:]]*"'"$2"'"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p'
}

# A field of the ArtifactEdit receipt, which arrives as an object or as its JSON text in a string.
receipt_field() {
  printf '%s' "$tool_response" | sed -nE 's/.*\\?"'"$1"'\\?"[[:space:]]*:[[:space:]]*\\?"?([0-9A-Za-z_-]+).*/\1/p'
}

with_sources() {
  mkdir -p "$state" && touch "$sources" && SYNC_KEY=$2 SYNC_VALUE=$3 awk -F '\t' -v OFS='\t' "$1" "$sources" > "$sources.$$" && mv "$sources.$$" "$sources"
}

session=$(string_field "$head" session_id | tr -cd 'A-Za-z0-9-')
pending="$state/pending/${session:-session}"
page_limits="A Tickloop page is this one file, and it loads only the external files the ArtifactEdit create description names. A file that loads any other external or local file is not synced, and neither is one Tickloop refuses: tell the user it was not synced and why, and leave the file as it is."

case $(string_field "$head" tool_name) in
  Artifact)
    action=$(string_field "$tool_input" action)
    [ -z "$action" ] || [ "$action" = publish ] || exit 0
    printf '%s' "$tool_input" | grep -qE '[{,][[:space:]]*"asset"[[:space:]]*:[[:space:]]*true' && exit 0
    file=$(string_field "$tool_input" file_path)
    case $file in
      *.[Hh][Tt][Mm][Ll] | *.[Hh][Tt][Mm]) ;;
      *) exit 0 ;;
    esac
    case $file in
      /*) ;;
      *) file="$(string_field "$head" cwd)/${file#./}" ;;
    esac
    mkdir -p "$state/pending" && printf '%s\n' "$file" > "$pending"
    record=$([ -f "$sources" ] && SYNC_KEY=$file awk -F '\t' '$1 == ENVIRON["SYNC_KEY"] { print $2 " " $3 }' "$sources")
    if [ -n "$record" ]; then
      id=${record% *}
      revision=${record#* }
      context="The user has turned on syncing pages published with the Artifact tool to Tickloop Artifacts. The page just published is the file $file, synced before to the Tickloop page $id at revision $revision. To sync it, replace that page's content with the whole content of the file using the Tickloop Artifacts ArtifactEdit tool (action replace, artifact_id $id, expected_revision $revision), and give the user its link. If it answers content_conflict, the Tickloop page changed after the last sync: ask the user before replacing it. If it answers not_found, the Tickloop page is gone: create a new one (action create, format page). $page_limits"
    else
      context="The user has turned on syncing pages published with the Artifact tool to Tickloop Artifacts. The page just published is the file $file. To sync it, create a Tickloop page from the whole content of the file using the Tickloop Artifacts ArtifactEdit tool (action create, format page), and give the user its link. $page_limits"
    fi
    printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$context"
    ;;
  "$TICKLOOP_EDIT_TOOL")
    id=$(receipt_field artifact_id)
    revision=$(receipt_field revision)
    case $revision in '' | *[!0-9]*) exit 0 ;; esac
    [ -n "$id" ] || exit 0
    case $(string_field "$tool_input" action) in
      create)
        [ "$(string_field "$tool_input" format)" = page ] && [ -f "$pending" ] || exit 0
        file=$(cat "$pending")
        rm -f "$pending"
        with_sources '$1 != ENVIRON["SYNC_KEY"]' "$file" "" && printf '%s\t%s\t%s\n' "$file" "$id" "$revision" >> "$sources"
        ;;
      replace)
        [ -f "$sources" ] || exit 0
        with_sources '$2 == ENVIRON["SYNC_KEY"] { $3 = ENVIRON["SYNC_VALUE"] } { print }' "$id" "$revision"
        rm -f "$pending"
        ;;
    esac
    ;;
esac
exit 0
