#/bin/sh


pulseaudio-control \
    --icons-volume " , , " \
    --icon-muted " " \
    --node-nicknames-from "device.description" \
    --node-nickname "alsa_output.pci-0000_00_1b.0.analog-stereo: Speakers" \
    --node-nickname "alsa_output.usb-Logitech_Logitech_USB_Headset-00.analog-stereo:Logitech USB" \
    listen

    #--node-nickname "alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo:  Headphones" \
