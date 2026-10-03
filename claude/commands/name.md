---
description: Register this pane as a named agent for nvim's :Watch
argument-hint: "<agent>"
allowed-tools: Bash(agent:*), Bash(planlog:*)
---

# name

Register this Claude pane under a name, so `:Watch <agent>` in nvim -- from any
other zellij tab -- can send `eb:` markers here.

    agent $ARGUMENTS

`agent` reads `ZELLIJ_PANE_ID` and `ZELLIJ_SESSION_NAME` from its own
environment, which is this pane, writes the registry entry, and renames the
zellij pane. The rename is not cosmetic: nvim uses the pane name to tell whether
this agent is still alive, because zellij reports success when writing to a pane
id that no longer exists.

Print the one line it returns. Nothing else.

If `$ARGUMENTS` is empty, ask for a name. Do not invent one.

## When markers arrive

Turns arrive looking like this:

    [planwatch] /home/erik/dev/dotfiles/plan.md
    These lines come from Erik's buffer, not the TUI. ...

    /home/erik/dev/dotfiles/plan.md:12  rewrite the send path in ruby

Each line after the header is an instruction from him; the `file:line` is where
he wrote it. Answer in this pane.

Never edit that file. It is his buffer -- writing to it fights his cursor. If
something belongs in it, say what to add.

## After answering

Log a summary so he has it beside the buffer:

    planlog <agent> "one or two lines, what changed and what is still open"

`:Watch` already logged his prompt with a timestamp; this appends the reply
under it in `<watched file>.log.md`. Keep it short -- it is a running index of
the session, not a transcript. Skip it only when the reply is a bare
acknowledgement.
