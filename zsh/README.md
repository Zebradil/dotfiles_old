# ZSH configuration files

## Dependencies

Install everything:

```sh
$ sudo pacman -S git base-devel
$ git clone https://github.com/Jguer/yay.git
$ cd yay
$ makepkg -si
$ yay -S bat exa neovim python-neovim antibody fzf ripgrep task tmux translate-shell
```

- [bat](https://github.com/sharkdp/bat)
- [exa](https://github.com/ogham/exa)
- [neovim](https://github.com/neovim/neovim)

Optional:

- [antibody](https://github.com/getantibody/antibody)
- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [task](https://taskwarrior.org/)
- [tmux](https://github.com/tmux/tmux)
- [translate-shell](https://github.com/soimort/translate-shell)

## Usage

Link the configuration in the HOME directory:

```sh
$ cd ~
$ ln -s <dotfiles repo>/zsh/.zshrc .zshrc
```

### Optional

For using plugins with antybody:

```sh
$ cd ~
$ ln -s <dotfiles repo>/zsh/.zsh_plugins .zsh_plugins
```

Extend configuration in `~/.zshrc.local`.
