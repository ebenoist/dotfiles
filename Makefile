.PHONY: install vim-install bspwm-install update

install: dotfiles configs vim-install

bspwm-install: dotfiles configs

dotfiles: home-dotfiles
configs: config-dirs

home-dotfiles:
	ln -sf ${PWD}/aliases ${HOME}/.aliases
	ln -sf ${PWD}/bash_profile ${HOME}/.bash_profile
	ln -sf ${PWD}/bashrc ${HOME}/.bashrc
	ln -sf ${PWD}/exports ${HOME}/.exports
	ln -sf ${PWD}/gitconfig ${HOME}/.gitconfig
	ln -sf ${PWD}/inputrc ${HOME}/.inputrc
	ln -sf ${PWD}/tmux.conf ${HOME}/.tmux.conf

config-dirs:
	mkdir -p ${HOME}/.config
	ln -sf ${PWD}/nvim ${HOME}/.config/nvim
	ln -sf ${PWD}/kitty ${HOME}/.config/kitty
	ln -sf ${PWD}/alacritty ${HOME}/.config/alacritty
	ln -sf ${PWD}/zellij ${HOME}/.config/zellij
	ln -sf ${PWD}/bspwm ${HOME}/.config/bspwm
	ln -sf ${PWD}/sxhkd ${HOME}/.config/sxhkd

vim-install:
	@echo "Plugins will be installed automatically by lazy.nvim on first startup"

update:
	@git pull