Erik's Dotfiles
---

## Install
This will create symlinks for config files in your home directory.

* `git clone git@github.com:ebenoist/dotfiles.git`
* `cd dotfiles`
* `make`

## Update
* `make update`

## devbox — isolated client work VMs
Per-client Lima VMs (`work-<client>`) — own disk, creds, and Tailscale node, so client
contexts stay separated from each other and the host.

Deps (Linux): `limactl`, `qemu`, `op` (1Password CLI). Run `devbox doctor` for install hints.

* `make vm` — create + boot the 1440 box (`devbox create 1440`)
* `devbox shell 1440` — shell in (or use Tailscale SSH once up)
* `devbox list` / `devbox stop 1440` / `devbox destroy 1440`

The Tailscale auth key is read from 1Password at create time (never written to disk).
Store it at the `op://` ref named in the client manifest.

**Add a client:** copy `lima/clients/1440.env` to `lima/clients/<name>.env`, set its
`OP_AUTHKEY_REF` / `DOTFILES_REPO` / sizing, then `devbox create <name>`.
Manifests are non-secret and committed; the VM template is `lima/devbox.yaml`.
