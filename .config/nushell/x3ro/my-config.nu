# {
#      # Load `direnv`
#      code: "
#        let direnv = (direnv export json | from json)
#        let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
#        $direnv | load-env
#      "
#    }

source ./generated/zoxide.nu

use ./modules/html-colors.nu

alias gg = lazygit
alias h = home-manager



