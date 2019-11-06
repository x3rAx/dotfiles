# docker-aliases.sh
####################

# Kill all running containers.
alias docker-kill-all='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias docker-clean-stopped-containers='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias docker-clean-untagged-images='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

alias docker-clean-dangling-volumes='printf "\n>>> Deleting dangling volumes\n\n" && docker volume rm $(docker volume ls -qf dangling=true)'

# Delete all stopped containers and untagged images.
alias docker-clean-all-unused='docker-clean-stopped-containers; docker-clean-untagged-images'


alias doc='docker-compose'
alias docup='doc up -d'

