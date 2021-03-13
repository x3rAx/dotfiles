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



## Update Subrepos

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

