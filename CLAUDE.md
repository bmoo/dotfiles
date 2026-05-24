# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal dotfiles repository for managing a comprehensive macOS development environment. It uses **Dotbot** as the installation framework, allowing the entire development environment to be bootstrapped with a single `./install` command.

## Key Technologies

- **Languages**: Go, Rust, Python, Lua, Perl, Shell (Zsh, Bash)
- **Editor**: Neovim (Lua-based configuration with lazy.nvim)
- **Shell**: Zsh with custom configuration
- **Multiplexer**: Tmux
- **Package Manager**: Homebrew
- **DevOps**: Docker, Kubernetes, Terraform
- **Databases**: PostgreSQL, SQLite

## Repository Structure

### `bin/` - Custom Scripts
Executable utilities for development workflows:
- **Git helpers** (git-autofixup, git-auto, git-rim, etc.) - Workflow automation for rebasing and interactive commits
- **Development tools** - Wrappers and utilities for Go testing, Docker, Kubernetes, and misc tasks
- **diarize.py** - Audio diarization tool using Whisper and PyAnnote

### `config/nvim/` - Neovim Configuration
Modular Lua-based configuration:
- `init.lua` - Entry point
- `lua/plugins/` - Plugin definitions and configurations (26+ files)
- `lsp/` - Language-specific LSP configurations (Go, Lua, Python)
- `lua/` - Core modules for completion, diagnostics, treesitter, DAP, etc.

**Key Pattern**: Plugin configurations are separated into feature files (appearance.lua, completion.lua, keymaps.lua, etc.) and language-specific files in `lsp/`. LSP configurations follow a shared pattern defined in `sharedlsp.lua`.

### `zsh.after/` - Shell Configuration
Modular Zsh setup:
- `alias.zsh` - Command aliases (Docker, Kubernetes, Go, utilities)
- `editor.zsh`, `prompt.zsh`, `path.zsh` - Environment setup
- Tool-specific configs: `go.zsh`, `nvm.zsh`, `pyenv.zsh`, `gcloud.zsh`, `kubectl.zsh`, `aws-vault.zsh`

### `dotbot/` - Bootstrapper (Git Submodule)
The Dotbot framework handling installation. Don't modify directly—it's pinned to a specific version.

### Root Configuration Files
- `install.conf.yaml` - Dotbot configuration: symlinks, environment setup, shell commands
- `install` - Bootstrap script (16 lines) - runs Dotbot with configuration
- `Brewfile` - Homebrew packages (102 brews, 7 taps, 4 casks, 10 app store apps)
- `gitconfig` - Git configuration with 30+ aliases and merge settings
- `tmux.conf` - Tmux configuration (prefix: Ctrl-A, vi keybindings)

## Installation and Setup

```bash
# Full environment setup (from repository root)
./install

# This will:
# 1. Initialize and update the dotbot submodule
# 2. Symlink configuration files to home directory
# 3. Clean broken symlinks
# 4. Install Homebrew packages
# 5. Install npm global packages (typescript, pyright)
# 6. Install Go language server
```

## Development Commands

### Git Aliases (from gitconfig)
```bash
git auto              # Rebase with autosquash against origin/main
git rim               # Interactive rebase against origin/main
git dauto, git rod    # Various rebasing shortcuts
git autofixup         # Intelligent autosquash for fixing commits
```

### Go Development (from Brewfile + zsh aliases)
```bash
go test             # Built-in Go testing
golangci-lint       # Linting tool included
delve               # Go debugger included
t                   # Alias for 'go test'
lint                # Go linting alias
cover               # Code coverage
depgraph            # Dependency graph
```

### Docker & Kubernetes (from zsh aliases)
```bash
dk                  # Docker shortcuts namespace
k                   # Kubernetes shortcuts namespace
kpod                # Kubernetes pod helpers
kforward            # Kubernetes port forwarding
klogs               # Kubernetes log viewing
```

### Common Utilities
```bash
lg                  # lazygit (Git UI)
tm                  # tmux
tf                  # terraform
ci                  # circleci
```

## Architecture Notes

### Dotbot Configuration Model
The repository uses a declarative YAML-based approach (install.conf.yaml) where:
- **Link blocks** define symlinks from repo files to home directory
- **Shell blocks** execute setup commands (package installation, submodule init, etc.)
- **Clean blocks** remove broken symlinks
Configuration is idempotent—running `./install` multiple times is safe.

### Neovim Plugin Organization
- **Plugin Manager**: lazy.nvim (defined in lua/plugins/)
- **Separation of Concerns**: Each feature/concern has its own file (keymaps.lua, completion.lua, diagnostics.lua, etc.)
- **Language-Specific LSP Setup**: Per-language configuration in `lsp/` directory (golang.lua, lua_ls.lua, pyright.lua)
- **Shared LSP Utilities**: Common LSP setup logic in `sharedlsp.lua` referenced by language-specific configs
- **Plugin Lock File**: `lazy-lock.json` pins plugin versions

### Shell Modularization
Configuration is split by concern (aliases, environment variables, tool-specific setup) in separate `.zsh` files within `zsh.after/` for maintainability and clarity.

## When Making Changes

### Adding a New Tool or CLI Utility
1. Add to Brewfile (or appropriate package manager in install.conf.yaml shell commands)
2. If it needs shell integration, create a new file in `zsh.after/` (e.g., `mytool.zsh`)
3. Run `./install` to test the setup

### Modifying Neovim Configuration
1. Edit the appropriate file in `config/nvim/lua/plugins/` or `config/nvim/lsp/`
2. If adding a new LSP, follow the pattern established in `sharedlsp.lua` and create a file in `lsp/`
3. Test by launching Neovim and verifying the configuration loads
4. Record non-obvious decisions in `config/nvim/docs/adr/` (see existing ADRs for format)

#### Verifying nvim changes via headless probe

For plugin-state assertions ("did barbar set the offset?", "what's the filetype of the Claude buffer?"), drive nvim headlessly and dump state to stderr:

```bash
nvim --headless /path/to/some/dir -c 'lua vim.defer_fn(function()
  local state = require("barbar.state")
  io.stderr:write("offset.left.width=" .. state.offset.left.width .. "\n")
  vim.cmd("qa!")
end, 3000)' 2>&1 | grep -v "^Ptmux"
```

- Open with a **directory argument** to trigger the VimEnter auto-open of neo-tree + claudecode.
- Use `vim.defer_fn(..., 3000)` to wait for the lazy-loaded plugins and scheduled startup chain to settle (~2-3s is usually enough).
- Write diagnostics to `io.stderr` and pipe through `2>&1` — the headless `:terminal` chatter goes to stdout otherwise.
- **Caveat**: `qa!` triggers `BufWinLeave`, which can fire cleanup handlers (e.g., barbar's `sidebar_filetypes` close hook resets `state.offset` to defaults). If a clean dump shows defaults but a traced run shows real values, you're observing post-cleanup state. Poll for the expected condition from inside Lua and `qa!` once it's met instead.
- For deeper investigation, monkey-patch a target function (`local orig = mod.fn; mod.fn = function(...) io.stderr:write(...); return orig(...) end`) to log every call.

### Adding Git Aliases
1. Edit `gitconfig`
2. Run `./install` to symlink the updated config

### Modifying Shell Configuration
1. Edit or add files in `zsh.after/` (naming should reflect the concern)
2. Run `./install` to symlink the updated files
3. Test by launching a new shell session

## macOS-Specific Considerations

- Configuration heavily uses Homebrew for package management
- Includes macOS App Store app management via `mas`
- Designed for Terminal.app, iTerm2, or Kitty
- Expects Xcode toolchain to be installed (Brewfile includes openjdk, but Xcode may be needed for some build tools)
- Git credential helper supports GitHub and Azure DevOps
