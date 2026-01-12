.PHONY: install sway-install update

install: home-dotfiles config-dirs claude-setup

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

update:
	@git pull
