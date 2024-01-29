#/bin/sh

# WARN: The gamemode start hook (in home-manager) currently just starts picom
#       and does not use this file. If you make changes here,
#       make sure to update the gamemode start hook as well.
# TODO: Find a way to always start picom with the desired config / arguments
pkill picom
#picom --experimental-backends # Experimental for blur with "dual_kawase"
picom
