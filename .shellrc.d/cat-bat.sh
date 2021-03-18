if [ "$(command -v bat)" ]; then
    alias cat="bat"
elif [ "$(command -v batcat)" ]; then
    alias cat="batcat"
    alias bat="batcat"
fi
