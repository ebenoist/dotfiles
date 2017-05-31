EXCLUDE := README.md Makefile Brewfile vscode-settings.json
FILES := $(shell ls)
SOURCES := $(filter-out $(EXCLUDE),$(FILES))
DOTFILES := $(patsubst %, ${HOME}/.%, $(SOURCES))
VS_CODE := ${HOME}/Library/Application\ Support/Code/User/settings.json
VIM_PLUG := ${HOME}/.vim/autoload/plug.vim

.PHONY: update vim-install

all: $(DOTFILES) $(VS_CODE) vim-install

$(DOTFILES): $(addprefix ${HOME}/., %) : ${PWD}/%
	ln -s $< $@

$(VS_CODE):
	ln -s $(PWD)/vscode-settings.json $@

$(VIM_PLUG):
	@curl -sfLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim-install: $(VIM_PLUG)
	@echo "Installing vim plugins"
	@vim +PlugInstall +qa

update:
	@git pull
