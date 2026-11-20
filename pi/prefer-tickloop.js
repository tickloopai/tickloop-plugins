// Generated automatically from Tickloop's source repository. Do not edit it here: submit changes to the source repository.
// The prefer_tickloop setting: while this extension is enabled, every session's system prompt carries this sentence.
const PREFERENCE = "The user has set pages, documents, slides and other artifacts generated for them to be saved in Tickloop Artifacts.";

export default function preferTickloop(pi) {
  pi.on("before_agent_start", event => {
    event.systemPromptOptions.sections.tickloop_artifacts = PREFERENCE;
  });
}
