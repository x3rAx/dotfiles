# .bash_paths

addpath () {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) PATH="$1${PATH:+:$PATH}$1"
    esac
}

# Add to $PATH (last entry weights most)
addpath "$HOME/.config/composer/vendor/bin"
addpath "$HOME/.local/npm-packages/bin"
addpath "$HOME/.local/bin/*/"
addpath "$HOME/.local/bin/"

unset addpath 
export PATH

# NODE_PATH
export NODE_PATH=$NODE_PATH:/home/x3ro/.local/npm-packages/lib/node_modules

