On your other machines (after you push)

- [ ] In ~/.zshrc, change the source line to source ~/configuration/shell/zshrc_ext.
- [ ] Run ln -sfn configuration/emacs/init.el ~/.emacs.
- [ ] Repeat steps 1 and 3 there.

# configuration

Personal dotfiles, Emacs setup and assorted scripts.

## Layout

```
shell/             zsh config — zshrc_ext is the entrypoint, sources the rest
  zshrc_ext          oh-my-zsh plugins, keybindings, env/PATH, sources below
  aliases            general aliases (git, rails, node, heroku, ngrok, ...)
  projects           project launchers (terminal_setuper), deploy, tool shortcuts
  functions          shell functions
  able               Able project helpers
emacs/
  init.el            main Emacs config (~/.emacs symlinks here)
  .emacs.d/          runtime dir (~/.emacs.d symlinks here; contents untracked)
  fedeaux-mode/      custom mode, themes, cli.rb
  yas-snippets/      yasnippet snippets
  haml-mode/         vendored haml-mode
terminal_setuper/  iTerm2 Python API scripts that open per-project tab layouts
tools/
  dev/               dev utilities (erb2slim, kill_ghost_processes, ...)
  finance/           investing/tax scripts and data (stocker/, genial notes, ...)
  scratch/           one-off experiments
notes/             misc notes and docs
.bk/               archived old configs
```

## Install

Install [oh-my-zsh](https://ohmyz.sh/), then:

```sh
git clone git@github.com:fedeaux/configuration.git ~/configuration
ln -s configuration/emacs/init.el ~/.emacs
ln -s configuration/emacs/.emacs.d ~/.emacs.d
echo 'source ~/configuration/shell/zshrc_ext' >> ~/.zshrc
```

Emacs packages install themselves on first launch (`use-package-always-ensure`).
The repo must live at `~/configuration` — several aliases and Emacs `load` calls assume it.
