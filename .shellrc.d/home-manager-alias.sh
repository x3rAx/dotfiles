hm() {
	local XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
    local hm_dir="${XDG_CONFIG_HOME}/home-manager"

	if [ "$1" = 'u' ] || [ "$1" = 'update' ]; then
		if [ ! -f "${hm_dir}/flake.nix" ]; then
			echo "No flake.nix found in \"${XDG_CONFIG_HOME}/home-manager/\""
			return
		fi
		nix flake update "${XDG_CONFIG_HOME}/home-manager/"
		home-manager switch
		return
	fi

	if [ "$1" = "e" ] || [ "$1" = "edit" ]; then
		shift
        pushd "$hm_dir" >/dev/null
		set -- edit "$@"
        home-manager "$@"
        popd >/dev/null
        return
    fi
	
    if [ "$1" = "s" ]; then
		shift
		set -- switch "$@"
	fi

	home-manager "$@"
}
