# dotfiles

Personal config and dotfiles, based on https://github.com/holman/dotfiles but simplified and uses [strap](https://github.com/MikeMcQuaid/strap) 
to do the initial bootstrapping.

strap will clone the `dotfiles` repo into `~/.dotfiles` symlink the relevant files and install programs via homebrew.

`zsh` is the shell of choice here and setup is configured for that. and most of the shell logic is in `/zsh/zshrc.symlink` whihc `source`s all the other `.zsh` located in the topic folders, in the right order
