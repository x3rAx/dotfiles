hm() {
	local XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
	if [ "$1" == 'u' ] || [ "$1" == 'update' ]; then
		if [ ! -f "${XDG_CONFIG_HOME}/home-manager/flake.nix" ]; then
			echo "No flake.nix found in \"${XDG_CONFIG_HOME}/home-manager/\""
			return
		fi
		nix flake update "${XDG_CONFIG_HOME}/home-manager/"
		home-manager switch
		return
	fi

	if [ "$1" == "e" ]; then
		shift
		set -- edit "$@"
	elif [ "$1" == "s" ]; then
		shift
		set -- switch "$@"
	fi

	home-manager "$@"
}

__hm() {
	__load_completion home-manager
	_home-manager_completions
}

complete -F __hm hm
