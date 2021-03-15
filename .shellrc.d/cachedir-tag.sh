if [ ! -f ~/.cache/CACHEDIR.TAG ]; then
    mkdir -p ~/.cache
    cat >~/.cache/CACHEDIR.TAG <<EOF
Signature: 8a477f597d28d172789f06886806bc55
# This file is a cache directory tag created by \`~/.shellrc.d/cachedir-tag.sh\`.
# For information about cache directory tags, see:
#   http://www.brynosaurus.com/cachedir/
EOF
fi