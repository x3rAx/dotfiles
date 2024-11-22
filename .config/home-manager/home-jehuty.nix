{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  nixpkgs-config = {
    permittedInsecurePackages = [
      #"electron-23.3.13" # For super-productivity
      #"electron-25.9.0" # For obsidian
    ];
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "burpsuite"
        "burpsuite-2023.5.3"
        "obsidian"
        "phpstorm"
        "rambox"
        "spotify"
        "teamspeak-client"
        # "electron-25.9.0" # For Obsidian
      ];
  };

  super-productivity-with-fix-for-wayland = pkgs.symlinkJoin {
    name = "super-productivity";
    paths = [pkgs.super-productivity];
    nativeBuildInputs = [pkgs.makeBinaryWrapper];
    postBuild = ''
      wrapProgram "$out/bin/super-productivity" \
        --append-flags '--enable-features=UseOzonePlatform --ozone-platform=wayland'
    '';
  };
in {
  imports = [
    #./home-env-packages.nix
    ./modules/nvim.nix
  ];

  nixpkgs.config = nixpkgs-config;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "x3ro";
  home.homeDirectory = "/home/x3ro";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = let
    external = {
    };
  in
    with pkgs; [
      anki
      bat
      unstable.bat-extras.batman
      brave
      #unstable.bruno # Postman alternative (plain text request files)
      #burpsuite
      #carla # Audio plugin host (Pipewire)
      cpulimit
      curlie
      unstable.deno
      distrobox
      duf
      eww
      fd
      firefox
      flakify
      fx
      fzf
      gdu
      grc
      handlr
      htop
      hurl
      inkscape
      insomnia # Postman alternative
      unstable.just
      kanata
      keepassxc
      kopia
      unstable.lazygit
      libappindicator
      libqalculate
      lolcat
      lsd
      unstable.minio-client
      neovide
      nerdfonts
      #netavark
      nh
      nix-direnv
      nodejs
      unstable.nushell
      unstable.obsidian
      oh-my-posh
      python3Packages.openrazer
      #(pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      p7zip
      python3Packages.pillow
      pipecontrol # Pipewire
      pipectl # Pipewire
      python3Packages.pystray
      python3
      remmina
      ripdrag
      ripgrep
      rmlint
      rye
      spotify
      super-productivity
      teams-for-linux
      teamspeak_client
      telegram-desktop
      unstable.thunderbird-bin
      tmux
      trash-cli
      udiskie
      #ungoogled-chromium
      wireplumber # Pipewire
      yazi
      yq-go # `jq` for Yaml
      zoxide
      zoxide
    ];

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
    EDITOR = "neovim";
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

  programs.script-directory = {
    enable = true;
    settings = {
      SD_ROOT = "${config.home.homeDirectory}/.sd";
      #SD_EDITOR = "nvim";
      #SD_CAT = "lolcat";
    };
  };

  # Enable `virsh` to access the local machines
  xdg.configFile."libvirt/libvirt.conf".text = ''
    uri_default = "qemu:///system"
  '';

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer" # Wayland: Allow display scaling in smaller steps than 100% / 200%
        #"x11-randr-fractional-scaling" # X11 fractional scaling - didn't work
      ];
      attach-modal-dialogs = false; # Do not move the parent window when moving a modal window
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      repeat-interval = mkUint32 25;
      delay = lib.hm.gvariant.mkUint32 200;
      numlock-state = true;
    };
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true; # To make EurKey work in Gnome
    };
    "org/gnome/desktop/wm/preferences" = {
      resize-with-right-button = true; # Resize windows with right mouse button
      mouse-button-modifier = "<Super>"; # Window resize modifier key
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.2; # [-1; 1]
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-windows = mkArray type.string ["<Alt>Tab"];
      switch-windows-backward = mkArray type.string ["<Shift><Alt>Tab"];
      switch-applications = mkArray type.string ["<Super>Tab"];
      switch-applications-backward = mkArray type.string ["<Shift><Super>Tab"];
      switch-group = mkArray type.string ["<Super>Escape"];
      switch-group-backward = mkArray type.string ["<Super><Alt>Escape"];

      switch-to-workspace-1 = mkArray type.string ["<Super>1"];
      switch-to-workspace-2 = mkArray type.string ["<Super>2"];
      switch-to-workspace-3 = mkArray type.string ["<Super>3"];
      switch-to-workspace-4 = mkArray type.string ["<Super>4"];
      switch-to-workspace-5 = mkArray type.string ["<Super>5"];
      switch-to-workspace-6 = mkArray type.string ["<Super>6"];
      switch-to-workspace-7 = mkArray type.string ["<Super>7"];
      switch-to-workspace-8 = mkArray type.string ["<Super>8"];
      switch-to-workspace-9 = mkArray type.string ["<Super>9"];
      switch-to-workspace-10 = mkArray type.string ["<Super>0"];

      move-to-workspace-1 = mkArray type.string ["<Shift><Super>1"];
      move-to-workspace-2 = mkArray type.string ["<Shift><Super>2"];
      move-to-workspace-3 = mkArray type.string ["<Shift><Super>3"];
      move-to-workspace-4 = mkArray type.string ["<Shift><Super>4"];
      move-to-workspace-5 = mkArray type.string ["<Shift><Super>5"];
      move-to-workspace-6 = mkArray type.string ["<Shift><Super>6"];
      move-to-workspace-7 = mkArray type.string ["<Shift><Super>7"];
      move-to-workspace-8 = mkArray type.string ["<Shift><Super>8"];
      move-to-workspace-9 = mkArray type.string ["<Shift><Super>9"];
      move-to-workspace-10 = mkArray type.string ["<Shift><Super>0"];
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = mkArray type.string [];
      switch-to-application-2 = mkArray type.string [];
      switch-to-application-3 = mkArray type.string [];
      switch-to-application-4 = mkArray type.string [];
      switch-to-application-5 = mkArray type.string [];
      switch-to-application-6 = mkArray type.string [];
      switch-to-application-7 = mkArray type.string [];
      switch-to-application-8 = mkArray type.string [];
      switch-to-application-9 = mkArray type.string [];
      switch-to-application-10 = mkArray type.string [];
    };
    "org/gnome/mutter/keybindings" = {
      switch-monitor = mkArray type.string ["<Alt><Super>p"];
    };
  };

  # TODO: Do I need this?
  #fonts.fontconfig.enable = true; # For nerdfonts?

  services.copyq.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.05"; # Please read the comment before changing.
}
