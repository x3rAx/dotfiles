# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

PATH="$HOME/.cargo/bin:$PATH"
export PATH

if [ -e "${HOME}/.linuxbrew/bin/brew" ]; then eval $("${HOME}/.linuxbrew/bin/brew" shellenv); fi
if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then . "${HOME}/.nix-profile/etc/profile.d/nix.sh"; fi # added by Nix installer

