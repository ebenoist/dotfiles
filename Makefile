.PHONY: install sway-install update vm vm-up vm-shell help tree-sitter

TREE_SITTER_VERSION := 0.26.10
TS_OS := $(shell uname -s | tr A-Z a-z | sed 's/darwin/macos/')
TS_ARCH := $(shell uname -m | sed 's/x86_64/x64/;s/aarch64/arm64/')

install: home-dotfiles config-dirs claude-setup ${HOME}/.local/bin/tree-sitter

sway-install: install

home-dotfiles:
	@for f in ${PWD}/home/*; do \
		ln -sf "$$f" "${HOME}/.`basename $$f`"; \
	done

config-dirs:
	@mkdir -p ${HOME}/.config
	@for d in ${PWD}/config/*; do \
		ln -sf "$$d" "${HOME}/.config/`basename $$d`"; \
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
