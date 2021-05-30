# n.bash
# ======
#
# `n` the node version manager

export N_PREFIX="$HOME/.local/opt/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH="$N_PREFIX/bin:$PATH"  # Added by n-install (see http://git.io/n-install-repo)

