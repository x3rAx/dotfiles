Kirby Setup
===========


Pacman Config
-------------

In `/etc/pacman.conf` uncomment the lines

    Color
    TotalDownload

In `/etc/pacman-mirrors.conf` set

    Protocols = https

Then run the command

    # pacman-mirrors -c Germany,Austria

to update mirrors.





TTY Font
--------

I'm using `terminus` font in `16x32` to have a reasonable font size on my 4K monitor. The font `ter-132n` covers the `ISO8859-1` for german umlauts. (See: ReadMe.txt - https://sourceforge.net/projects/terminus-font/)

`/etc/vconsole.conf`

    KEYMAP=en
    FONT=ter-132n





Unicode / Powerline Airline Fonts
---------------------------------

I don't know what fixed it in the end but now I'm using the 
`community/rxvt-unicode` and have `community/ttf-dejavu-sans-mono-powerline`
installed and in my `.Xresources` I have set the font to:

    URxvt.font: \                                                                    
        xft:DejaVu Sans Mono for Powerline:size=10:antialias=true:hinting=true, \
        xft:TerminessTTFNerdFontMono:size=16

The `TerminessTTFNerdFontMono` solved missing icons in ranger.





Fix Directories opening in VSCode
---------------------------------

VSCode comes with a desktop file that sets it's mime-type to `inode/directory`:

    MimeType=text/plain;inode/directory;

This causes it to be registered as default application for opening directories.

To fix this, install `nemo` and run:

    $ xdg-mime default nemo.desktop inode/directory





Install Printer
---------------

The tool `system-config-printer` uses the CUPS backend to manage printers. It
needs `lxpolkit` to ask for passwords. `lxpolkit` is included in the package
`lxsession`.

    # pacman -S lxsession

then start `lxpolkit` (consider autostarting it):

    $ lxpolkit &

If setting up the printer with `system-config-printer` fails, it might be due to
the `.local` resolution issue 
(https://wiki.archlinux.org/index.php/CUPS/Troubleshooting#Unable_to_locate_printer).
Try the fix for "Unable to locate printer" below.



### Fix "Unable to locate printer" ###

Cups might not be able to resolve `.local` TLDs. To fix this, install
`nss-mdns` and enable the `awahi` service:

    # pacman -S nss-mdns
    # sudo systemctl enable --now avahi-dnsconfd.service

NOTE: In my case the /etc/nsswitch.conf already had `mdns4_minimal` configured.

Edit `/etc/nsswitch.conf` and change the `hosts` line to include 
`mdns_minimal [NOTFOUND=return]` before `resolve` and `dns`:

    hosts: ... mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns ...
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--.
                                               `-- Add this if it is missing

Note: If you experience slowdowns in resolving .local hosts try to use 
`mdns4_minimal` instead of `mdns_minimal`.

