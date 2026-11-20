// This repository is generated.
// The prefer_tickloop setting: while this extension is enabled, every session's system prompt carries this text.
const PREFERENCE = "The user has set pages, documents, slides and other artifacts generated for them to be saved in Tickloop Artifacts. When the Tickloop Artifacts tools are missing or need sign-in, the user wants to be asked first to sign in to Tickloop through the tickloop-artifacts MCP server, with nothing saved elsewhere until then. In pi, the user signs in by running /mcp login tickloop-artifacts in the session.";

export default function preferTickloop(pi) {
  pi.on("before_agent_start", event => {
    event.systemPromptOptions.sections.tickloop_artifacts = PREFERENCE;
  });
}
