# Introduction to playtinum dotfiles

      ██████╗ ██╗      █████╗ ██╗   ██╗████████╗██╗███╗   ██╗██╗   ██╗███╗   ███╗          ✨
      ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝╚══██╔══╝██║████╗  ██║██║   ██║████╗ ████║      ✧
      ██████╔╝██║     ███████║ ╚████╔╝    ██║   ██║██╔██╗ ██║██║   ██║██╔████╔██║   ★
      ██╔═══╝ ██║     ██╔══██║  ╚██╔╝     ██║   ██║██║╚██╗██║██║   ██║██║╚██╔╝██║ ✦
      ██║     ███████╗██║  ██║   ██║      ██║   ██║██║ ╚████║╚██████╔╝██║ ╚═╝ ██║
      ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝

These dotfiles are mainly used on Windows WSL with Ubuntu and sometimes MacOS.

I aim to improve these to get the best possible dev-environment
with [NeoVim](https://neovim.io/) currently based on [LazyVim config](https://www.lazyvim.org/)

## Setup

### WezTerm

On Windows I use [WezTerm](https://wezterm.org/install/windows.html).
Let's install this first.

Install [this NerdFont](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/IntelOneMono.zip)

Make sure [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) is setup.

```ps1
wsl --install -d Ubuntu
```

Copy `.config/wezterm` to `%USERPROFILE%/.config/wezterm`

Start WezTerm and if not already in wsl run:

```ps1
wsl -d Ubuntu
```

### Homebrew

Install [Homebrew](www.brew.sh) for easy installation of software

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### NeoVim

```bash
brew install neovim git lazygit gcc curl nvm fzf ripgrep fd
```
