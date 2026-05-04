# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io). Covers shell, editor, terminal, and git — with a clean separation between work and personal environments.

## Quick start

```sh
chezmoi init --apply https://github.com/ravisumit33/dotfiles
```

You'll be prompted for a work directory path, work email, and SSH key during setup.

## Stack

| Layer           | Tool                                                                                        |
| --------------- | ------------------------------------------------------------------------------------------- |
| Shell           | Zsh + [sheldon](https://github.com/rossmacarthur/sheldon) + [starship](https://starship.rs) |
| Editor          | [Neovim](https://neovim.io) via [LazyVim](https://lazyvim.org)                              |
| Terminal        | [Kitty](https://sw.kovidgoyal.net/kitty/)                                                   |
| Multiplexer     | [Tmux](https://github.com/tmux/tmux)                                                        |
| Tool versions   | [mise](https://mise.jdx.dev)                                                                |
| Dotfile manager | [chezmoi](https://www.chezmoi.io)                                                           |
