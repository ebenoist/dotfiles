.PHONY: install sway-install update vm vm-up vm-shell help tree-sitter check fix

TREE_SITTER_VERSION := 0.26.10
TS_OS := $(shell uname -s | tr A-Z a-z | sed 's/darwin/macos/')
TS_ARCH := $(shell uname -m | sed 's/x86_64/x64/;s/aarch64/arm64/')

install: home-dotfiles config-dirs claude-setup ${HOME}/.local/bin/tree-sitter

sway-install: install

home-dotfiles:
	@for f in ${PWD}/home/*; do \
		ln -sfn "$$f" "${HOME}/.`basename $$f`"; \
	done

# -sfn, not -sf: the destination is already a symlink to a directory after the
# first run, and ln would follow it and create the link inside, leaving a
# self-referential config/<name>/<name> in this repo every time.
config-dirs:
	@mkdir -p ${HOME}/.config
	@for d in ${PWD}/config/*; do \
		ln -sfn "$$d" "${HOME}/.config/`basename $$d`"; \
	done

claude-setup:
	@mkdir -p ${HOME}/.claude
	@rm -rf ${HOME}/.claude/commands
	@ln -sf ${PWD}/claude/commands ${HOME}/.claude/commands
	@ln -sf ${PWD}/claude/settings.json ${HOME}/.claude/settings.json
	@ln -sf ${PWD}/claude/keybindings.json ${HOME}/.claude/keybindings.json
	@ln -sf ${PWD}/claude/CLAUDE.md ${HOME}/CLAUDE.md

# nvim-treesitter (main) compiles parsers with tree-sitter-cli; apt's is too old
tree-sitter: ${HOME}/.local/bin/tree-sitter

${HOME}/.local/bin/tree-sitter:
	@mkdir -p $(@D)
	@curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/download/v${TREE_SITTER_VERSION}/tree-sitter-${TS_OS}-${TS_ARCH}.gz | gunzip > $@
	@chmod +x $@

# -I skips the downloaded binaries in bin/ — without it grep matches a shebang
# in ELF bytes and shellcheck tries to parse chainlink.
RUBY_SCRIPTS := $(shell grep -lIE '^\#!.*ruby' bin/* 2>/dev/null)

# rpxc is vendored upstream; linting it means linting someone else's style.
VENDOR_SCRIPTS := bin/rpxc
SH_SCRIPTS := $(filter-out $(VENDOR_SCRIPTS),$(shell grep -lIE '^\#!.*(bash|sh)\b' bin/* 2>/dev/null))

check: .make/standardrb .make/shellcheck

fix:
	@standardrb --fix $(RUBY_SCRIPTS)

.make:
	@mkdir -p $@

.make/standardrb: $(RUBY_SCRIPTS) | .make
	standardrb $(RUBY_SCRIPTS)
	@touch $@

.make/shellcheck: $(SH_SCRIPTS) | .make
	shellcheck -S warning $(SH_SCRIPTS)
	@touch $@

dns-watch: /etc/systemd/system/dns-watch.service

/etc/systemd/system/dns-watch.service: systemd/system/dns-watch.service bin/dns-watch
	sudo install -m 644 $< $@
	sudo systemctl daemon-reload
	sudo systemctl restart dns-watch
	sudo systemctl enable dns-watch

update:
	@git pull

vm:
	@bin/devbox create 1440

vm-up:
	@bin/devbox up 1440

vm-shell:
	@bin/devbox shell 1440

help:
	@bin/devbox help
	@echo
	@echo "scripts in bin/:"
	@ls bin | sed 's/^/  /'
