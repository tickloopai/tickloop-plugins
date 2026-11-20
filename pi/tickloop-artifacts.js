// This repository is generated.
// Registers the Artifacts MCP for each session only; pi signs in to it with its own MCP OAuth.
const SERVER = {"url":"https://tickloop.ai/artifacts/mcp","headers":{"X-Tickloop-Plugin":"1"},"oauth":{"scope":"artifacts.agent offline_access"}};

export default function tickloopArtifacts(pi) {
  pi.registerMcpServer("tickloop-artifacts", SERVER);
}
