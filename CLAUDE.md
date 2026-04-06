# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **chezmoi**-managed dotfiles repository. Chezmoi maps files using naming conventions (e.g., `dot_zshrc` → `~/.zshrc`, `dot_config/` → `~/.config/`). Files ending in `.tmpl` are Go templates processed by chezmoi before deployment.

## Common Commands

```bash
chezmoi apply              # Apply dotfiles to home directory
chezmoi diff               # Preview changes before applying
chezmoi add ~/.config/X    # Add a new config file to the repo
chezmoi edit ~/.config/X   # Edit a managed file
chezmoi cd                 # cd into this source directory
```

## Chezmoi Templating

- **`.chezmoi.toml.tmpl`** — Main config template; prompts for `work.dirname` and `work.email` via `promptStringOnce`
- Templates use Go template syntax (`{{ .variable }}`) and chezmoi data from `.chezmoi.toml`
- Conditional logic is used to separate work vs. personal configurations (git user, prettier formatting)

## Key Templated Files

- `dot_gitconfig.tmpl` — Git config with conditional `includeIf` for work directory
- `dot_gitconfig-work.tmpl` — Work git config using `{{ .work.email }}`
- `dot_config/nvim/lua/plugins/conform.lua.tmpl` — Disables prettier in work directory

## Tool Stack

- **Shell**: Zsh + Oh-My-Zsh + sheldon (plugin manager) + starship (prompt)
- **Editor**: Neovim with LazyVim framework, plugins in `dot_config/nvim/lua/plugins/`
- **Terminal**: Kitty
- **Multiplexer**: Tmux
- **Tool versions**: Managed by mise (`dot_config/mise/config.toml`)

## Neovim Plugin Architecture

Custom plugins live in `dot_config/nvim/lua/plugins/`. LazyVim extras are declared in `dot_config/nvim/lazyvim.json`. A custom agent terminal utility (`dot_config/nvim/lua/utils/agent.lua`) creates persistent tmux sessions per project.

## Neovim Keybinding Rules

When adding or modifying keybindings, always check for conflicts first:
1. Scan all files in `dot_config/nvim/lua/plugins/` and `dot_config/nvim/lua/config/` for existing `keys` and `vim.keymap.set` definitions.
2. Check LazyVim default keymaps — this config uses LazyVim, so many `<leader>` combos are already taken (see lazyvim.org/keymaps).
3. Pick keys that are semantically related to nearby bindings (e.g., `<C-.>` next to `<C-,>` for related functionality).