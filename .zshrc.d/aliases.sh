# .bash_aliases

# Reload .bashrc
alias reload-zshrc='. ~/.zshrc'
alias RR='reload-zshrc'

# cd
alias -- '-'='cd -'
alias '..'='cd ..'

# ls
alias ll='ls -lF'
alias la='ls -alF'
alias l='ls -CF'


# Preserve PATH on sudo command
#alias sudo='sudo env PATH=$PATH'

# Run aliases with sudo (the space at the end is important)
alias asudo='sudo -E '

# ssh-tmp
alias ssh-tmp='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias ssh-vm='ssh-tmp'
alias scp-tmp='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# Android
#alias adb='sudo adb'
alias fastboot='sudo fastboot'

# ACK
#alias ack='ack-grep'

# grep
alias highlight='grep -z'

# dd with progress
#alias ddd='dcfldd'
alias ddd='dd status=progress'

# MPO
#alias mpo='cd ~/Projects/CPL/MPO'
#alias mpo-up='mpo && vagrant up'
#alias mpo-ssh='mpo && vagrant ssh'

# Fix HDD
#alias fix-hdd='sudo dd if=/dev/sdb of=/dev/zero bs=1M count=5'
alias hdd-sleep='sudo hdparm -Y /dev/sdb'

# gpg
alias gpg1='\gpg'
alias gpg='\gpg2'

# List user installed packages
alias pacman-list-user-installed='comm -23 <(pacman -Qqett | sort | uniq) <(pacman -Qqg base -g base-devel | sort | uniq) | xargs -i pacman -Qs {}'

# ranger-cd
alias r=ranger-cd

# Disk usage (ncdu)
alias disk-usage='ncdu'
alias disk-usage-partition='ncdu -rx'

alias cp-rsync="rsync -a --info=progress2 --no-i-r"

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

