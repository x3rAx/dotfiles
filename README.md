# 🐧 ^x3ro's Dotfiles

Welcome to my dotfiles repo 😺



## 💻 Setup a New Machine

Use `yadm` to clone this repo:

    yadm clone git@gitlab.com:x3ro/dotfiles.git

or

    yadm clone https://gitlab.com/x3ro/dotfiles.git


### 🦄 Easy Setup

For an easy setup with bootstrapping and without `yadm` installed use:

    curl -L https://gitlab.com/x3ro/dotfiles/-/raw/master/.local/subrepos/yadm/yadm | bash -s clone git@gitlab.com:x3ro/dotfiles.git --bootstrap



### 🔱 Yadm Classes

Set the machine class using `yadm config local.class <class>`

The following classes are available:

- `_unknown_*_`: (* is wildcard) Files that contain config that has been
  (but is not currently) in use and for which I have no idea if I will need
  them someday 🙈



## 💪 Update Subrepos

`git-subrepo` conflicts with `yadm`. The easiest way to update subrepos is by
checking out the repo with `git` in a temporary directory and update subrepos
there:

```bash
$ tmp="$(mktemp -d)"
$ git clone git@gitlab.com:x3ro/dotfiles.git "$tmp"
$ cd "$tmp"
$ git config user.name "^x3ro"
$ git config user.email "git@x3ro.dev"
$ git subrepo pull --all
$ git push
$ cd ~
$ rm -rf "$tmp"
$ yadm pull
```

## 🛠️ Useful Tools

- [`bat`](https://github.com/sharkdp/bat) - A cat(1) clone with wings (see [`~/.shellrc.d/cat-bat.sh`](.shellrc.d/cat-bat.sh))
- [`exa`](https://github.com/ogham/exa) - A modern replacement for ‘ls’ (see [`~/.shellrc.d/ls-exa.sh`](.shellrc.d/ls-exa.sh))
- [`fd`](https://github.com/sharkdp/fd) - A simple, fast and user-friendly alternative to 'find'
- [`ripgrep`](https://github.com/burntsushi/ripgrep) - An blazing fast alternative for `find` ("ripgrep recursively searches directories for a regex pattern while respecting your gitignore")
