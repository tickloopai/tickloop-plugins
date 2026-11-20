---
name: open
description: Open a Tickloop artifact from its link or ID, including one made in another agent or under another account - read it, sum up where it stands, and wait for what to change. Also reads and replies to the comments on it when the user asks to see them.
argument-hint: <artifact link or ID>
---

# Open an artifact

Open the Tickloop artifact whose link or ID the user gave. The artifact belongs to the user's Tickloop account, so the Tickloop Artifacts tools can read and change it whichever agent or account made it.

1. Find the artifact ID in what the user gave:
   - An ID is 22 letters and digits, or a hyphenated UUID.
   - An artifact link has the ID right after `/artifacts/`, as in `https://tickloop.ai/artifacts/<id>`, `/artifacts/<id>/edit` and `/artifacts/embed/<id>`.
   - A shared link (`/artifacts/s/...`) does not carry the ID. Ask the user for the artifact's own link.
   - When the user gave neither, ask for the link or ID.
2. Read it: call `ArtifactRead` with `action: "read"` and that `artifact_id`. When the result gives a `next_cursor`, pass it as `cursor` to read on until you have what you need to describe the artifact.
3. Tell the user in a few lines what it is and where it stands: its title, its format, and what it holds now.
4. Then wait for the user to say what to change. Change nothing before they do. When they do, change this same artifact with the Tickloop Artifacts tools, as their descriptions say.

## Comments

When the user asks to see the comments on it, call `ArtifactRead` with `action: "threads"`, the same `artifact_id` and `status: "all"`, and sum up each thread: who said what, and whether it is still open. Reply on a thread only when the user asks, with `ArtifactComment` with `action: "reply"`, its `thread_id` and the text.
