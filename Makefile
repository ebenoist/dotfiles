EXCLUDE := README.md Makefile Brewfile vscode-settings.json vscode-keybindings.json
FILES := $(shell ls)
SOURCES := $(filter-out $(EXCLUDE),$(FILES))
DOTFILES := $(patsubst %, ${HOME}/.%, $(SOURCES))
VS_CODE_SETTINGS := ${HOME}/Library/Application\ Support/Code/User/settings.json
VS_CODE_KEYBINDINGS := ${HOME}/Library/Application\ Support/Code/User/keybindings.json
VIM_PLUG := ${PWD}/nvim/autoload/plug.vim

.PHONY: update vim-install

install: all

all: $(DOTFILES) ${HOME}/.config/nvim  vim-install ${HOME}/.config/kitty

$(DOTFILES): $(addprefix ${HOME}/., %) : ${PWD}/%
	ln -s $< $@

${HOME}/.config/nvim: ${PWD}/nvim
	ln -s $< $@

${HOME}/.config/kitty: ${PWD}/kitty
	ln -s $< $@

$(VS_CODE_SETTINGS):
	ln -s $(PWD)/vscode-settings.json "$@"

$(VS_CODE_KEYBINDINGS):
	ln -s $(PWD)/vscode-keybindings.json "$@"

$(VIM_PLUG):
	@curl -sfLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim-install: $(VIM_PLUG)
	@echo "Installing vim plugins"
	@nvim +PlugInstall +qa

update: all
	@git pull
