{ config, pkgs, mkUnstable, lib, ... }:

let
  nixpkgs-config = {
    permittedInsecurePackages = [
      "electron-24.8.6"
      "electron-25.9.0"
    ];
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "cudatoolkit"
      "discord"
      "obsidian"
      "vscode"
    ];
  };
  unstable = mkUnstable { config = nixpkgs-config; };
in
{
  imports = [
    ./overlays
  ];

  nixpkgs.config = nixpkgs-config;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "x3ro";
  home.homeDirectory = "/home/x3ro";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    android-tools
    autorandr
    barrier
    binutils
    cinnamon.nemo
    cli-visualizer # CLI audio visualizer
    cryptomator
    dbeaver
    deadd-notification-center
    discord
    distrobox
    duf
    element-desktop
    evcxr # Rust REPL
    eww # Status bar
    expect
    filezilla
    fish
    fx # Terminal JSON viewer
    gamescope # Restrict mouse to game
    gimp
    glxinfo
    gparted
    handlr
    htmlq
    httpie
    httrack
    inxi
    kitty
    kopia
    lazygit
    libreoffice
    lolcat
    lsd
    mangohud
    mimeo
    multitail
    neofetch
    nerdfonts
    nix-direnv
    nmap
    nvtop
    oh-my-posh
    openfortivpn
    parallel
    pavucontrol
    pcmanfm
    protonup-qt # Manage Steam games & ProtonGE versions
    qpwgraph # Pipewire connection graph
    qutebrowser
    razer-battery-tray
    remmina
    ripgrep-all
    shutter
    spectacle
    spice-gtk
    sshpass
    stalonetray # Used to hack tray icons into my eww bar
    tesseract5
    tldr # Simplified man pages
    udiskie
    unclutter-xfixes
    ventoy-bin-full # or `ventoy-bin`?
    whois
    wireguard-tools
    xorg.xhost
    xorg.xkill
    xorg.xwininfo
    xournalpp
    xsecurelock
    xss-lock

  ]) ++ (with unstable; [

    easyeffects
    just
    nushell
    obsidian
    quickemu
    telegram-desktop
    thunderbird-bin
    zoxide

  ]);

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/x3ro/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
