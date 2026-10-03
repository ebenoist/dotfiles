---
description: Activate vim-bridge mode -- read/edit nvim buffers over RPC, act on eb: markers
allowed-tools: Bash(vimbuf:*)
---

# vim

Turn on buffer access to the nvim hosting this pane.

    vimbuf ls
    vimbuf markers

If `$NVIM` is unset, say so and stop -- this pane isn't a `:terminal` split
inside nvim, `vimbuf` will refuse.

Handle whatever `vimbuf markers` already finds, per the protocol below. Then
stay active: from here on for the rest of this pane's life, run
`vimbuf markers` before answering any message, not just right after `/vim`.

## Handling `eb:` markers

Bare `eb:` in a live buffer -- not the `eb: claude:` git-review tag from
CLAUDE.md, which is for diffs after the fact. This one is live, in-buffer,
any filetype.

For each marker `vimbuf markers` finds:

1. Read context: `vimbuf cat <bufnr>`.
2. Decide:
   - **Clear code change** -- write it with `vimbuf apply`, a JSON edit
     batch on stdin-free file: `[{"bufnr":N,"start":S,"end":E,"lines":[...]}]`,
     0-indexed half-open, matching `nvim_buf_set_lines` exactly. Replace the
     marker's own line, or make the edit it's pointing at elsewhere in the
     same buffer.
   - **Question / review** -- answer in chat, then
     `vimbuf log <file> "<one-line summary>"` so there's a record even if
     this pane isn't being watched when the reply lands.
3. Either way, clear the marker line itself as part of resolving it -- an
   `apply` edit with `"lines":[]` over its range. Never leave a handled
   `eb:` sitting in the buffer.

Scope edits tightly to what the marker is actually about. Don't reformat or
touch unrelated lines in a buffer Erik might be mid-edit in.
