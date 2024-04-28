cdwhich() {
	cd $(dirnamewhich "$@")
}

complete -c which cdwhich
