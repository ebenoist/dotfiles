EXCLUDE := README.md Makefile Brewfile vscode-settings.json vscode-keybindings.json
FILES := $(shell ls)
SOURCES := $(filter-out $(EXCLUDE),$(FILES))
DOTFILES := $(patsubst %, ${HOME}/.%, $(SOURCES))
VS_CODE_SETTINGS := ${HOME}/Library/Application\ Support/Code/User/settings.json
VS_CODE_KEYBINDINGS := ${HOME}/Library/Application\ Support/Code/User/keybindings.json
VIM_PLUG := ${HOME}/.vim/autoload/plug.vim

.PHONY: update vim-install

all: $(DOTFILES) $(VS_CODE_SETTIGNS) $(VS_CODE_KEYBINDINGS) vim-install

$(DOTFILES): $(addprefix ${HOME}/., %) : ${PWD}/%
	ln -s $< $@

$(VS_CODE_SETTINGS):
	ln -s $(PWD)/vscode-settings.json "$@"

$(VS_CODE_KEYBINDINGS):
	ln -s $(PWD)/vscode-keybindings.json "$@"

$(VIM_PLUG):
	@curl -sfLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim-install: $(VIM_PLUG)
	@echo "Installing vim plugins"
	@vim +PlugInstall +qa

update: all
	@git pull
