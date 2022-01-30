# Add `AddKeysToAgent yes` to your `~/.ssh/config` to automatically add
# keys when they are used.

# Uncomment to reset $GIT_SSH for git bash on windows
#unset GIT_SSH

# Set timeout for ssh agent in seconds (empty for default timeout)
SSH_AGENT_TIMEOUT=

# Set up ssh-agent
SSH_AGENT_ENV="$HOME/.ssh/.agent.env"

function __ssh_start_agent {
    #echo "Initializing new SSH agent..."
    touch $SSH_AGENT_ENV
    chmod 600 "${SSH_AGENT_ENV}"
    if [[ -n $SSH_AGENT_TIMEOUT ]]; then
        __timeout="-t ${SSH_AGENT_TIMEOUT}"
    fi
    ssh-agent $__timeout | sed 's/^echo/#/' > "${SSH_AGENT_ENV}"
    unset __timeout
    . "${SSH_AGENT_ENV}" > /dev/null
    #ssh-add
}

# Source SSH settings, if applicable
if [ -f "${SSH_AGENT_ENV}" ]; then
    . "${SSH_AGENT_ENV}" > /dev/null
    # Check if `ssh-agent` with PID from env file is running
    __is_ssh_agent_running=$(
        ps ax -o pid,user,cmd \
        | awk -v PID="$SSH_AGENT_PID" -v USER="$USER" -v CMD="ssh-agent" \
            '($1 == PID && $2 == USER && $3 == CMD) { print 1 }'
    )
    if [ "${__is_ssh_agent_running}" != "1" ]; then
        __ssh_start_agent
    fi
    unset __is_ssh_agent_running
else
    __ssh_start_agent
fi