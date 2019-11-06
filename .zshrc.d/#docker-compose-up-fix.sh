# docker-compose-up-fix
#########################

# DISCLAIMER
#
#     I do not take any responsibility and I'm not liable for any damage caused
#     through the usage of this script.
#
# I have tested every case I can think of and I'm pretty confident, that there
# are no major errors in this script but future versions of `docker-compose`
# might introduce changes that interfere with this wrapper.
#
# ==> Use at your own risk! <==
#

function docker-compose {
    local up=false
    local opts=()
    local subopts=()
    local attach=false
    local detach_option='--detach'
    local sudo=''

    # Run with sudo?
    if [[ $1 == '--sudo--' ]]; then
        shift
        sudo=sudo
    fi

    # If no arguments are given, execute docker-compose as if nothing happened
    if [[ $# == 0 ]]; then
        command $sudo docker-compose "$@"
        return $?
    fi

    for arg in "$@"; do
        if [[ $up == false ]]; then
            # Skip optional arguments before the first subcommand
            if [[ $arg =~ /^- ]]; then
                opts+=("$arg")
                continue
            fi

            # If the subcommand is 'up', set flag and continue with next $arg
            if [[ $arg == 'up' ]]; then
                up=true
                continue
            fi

            # If subcommand is not 'up' execute docker-compose as if nothing happened
            command $sudo docker-compose "$@"
            return $?
        fi

        # Handle help
        if [[ $arg =~ ^(-h\|--help)$ ]]; then
            command $sudo docker-compose up --help \
                | awk '
                    BEGIN { detach=0 }
                    /^    -/            { detach=0 }
                    /^    -d, --detach/ { detach=1 }
                    detach == 0         { print $0 }
                    /^Options:$/ {
                        print "    --attach                   Attached mode: Run containers in the foreground.";
                        print "                               Required for --abort-on-container-exit."
                    }
                ' # /awk
            return
        fi

        # Check for attach option
        if [[ $arg == '--attach' ]]; then
            attach=true
            continue
        fi

        # Check for detach option
        if [[ $arg =~ ^(-d\|--detach)$ ]]; then
            detach=true
            continue
        fi

        # Save subcommand options
        subopts+=("$arg")
    done

    # Check for conflicting options
    if [[ $attach == true ]] && [[ $detach == true ]]; then
        echo >&2 "WARNING: Detach option supplied together with attach option. Ignoring attach option."
        attach=false
    fi

    # Unset detach option if --attach is supplied
    if [[ $attach == true ]]; then
        detach_option=''
    fi

    # Execute docker-compose up
    command $sudo docker-compose ${opts[@]} up $detach_option ${subopts[@]}
    return $?
}

# For those who are not in the `docker` group
function sudo {
    if [[ $1 == 'docker-compose' ]]; then
        docker-compose --sudo-- "$@"
        return $?
    fi

    command sudo "$@"
    return $?
}
