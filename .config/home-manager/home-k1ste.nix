{
  config,
  pkgs,
  mkNixpkgs,
  mkUnstable,
  lib,
  vscode-extensions,
  inputs,
  ...
}: let
  nixpkgs-config = {
    permittedInsecurePackages = [
      "electron-24.8.6"
      "electron-25.9.0"
    ];
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) ([
          "aseprite"
          "discord"
          "obsidian"
          "vscode"
        ]
        ++ [
          # Stuff for `nvtop`
          "cuda-merged"
          "cuda_cccl"
          "cuda_cudart"
          "cuda_cuobjdump"
          "cuda_cupti"
          "cuda_cuxxfilt"
          "cuda_gdb"
          "cuda_nvcc"
          "cuda_nvdisasm"
          "cuda_nvml_dev"
          "cuda_nvprune"
          "cuda_nvrtc"
          "cuda_nvtx"
          "cuda_profiler_api"
          "cuda_sanitizer_api"
          "libcublas"
          "libcufft"
          "libcurand"
          "libcusolver"
          "libcusparse"
          "libnpp"
          "libnvjitlink"
        ]);
  };
  unstable = mkUnstable {config = nixpkgs-config;};

  godot-libraries = with pkgs; [
    stdenv.cc.cc.lib # For git support
  ];
  godot-with-libs = let
    godot-package = unstable.godot_4;
  in
    pkgs.symlinkJoin {
      name = godot-package.name + "-with-libs";
      paths = [godot-package];
      nativeBuildInputs = [pkgs.makeBinaryWrapper];
      postBuild = ''
        wrapProgram "$out/bin/godot4" \
          --set LD_LIBRARY_PATH '${lib.makeLibraryPath godot-libraries}'

        cp --remove-destination \
          $(readlink -f $out/share/applications/org.godotengine.Godot4.desktop) \
          $out/share/applications/org.godotengine.Godot4.desktop
        sed -i 's|^\(Name=.*\)|\1 (with libs)|g' \
          $out/share/applications/org.godotengine.Godot4.desktop
        sed -i "s|^Exec=[^[:space:]]*|Exec=$out/bin/godot4|g" \
          $out/share/applications/org.godotengine.Godot4.desktop
      '';
    };
in {
  imports = [
    ./modules/nvim.nix
    ./modules/vscode.nix
    ./modules/gamemode-config.nix
    ./overlays
  ];

  nixpkgs.config = nixpkgs-config;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "x3ro";
  home.homeDirectory = "/home/x3ro";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    (with pkgs; [
      age
      android-tools
      unstable.armagetronad # Game
      aseprite
      autorandr
      barrier
      binutils
      btrfs-assistant # GUI for btrfs
      bvi # VI like hex editor
      cli-visualizer # CLI audio visualizer
      cryptomator
      dbeaver-bin
      deadd-notification-center
      discord
      distrobox
      duf
      easyeffects
      element-desktop
      evcxr # Rust REPL
      eww # Status bar
      expect
      filezilla
      inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin
      fish
      flameshot # Screenshot tool
      nvtopPackages.full
      fx # Terminal JSON viewer
      gamescope # Restrict mouse to game
      unstable.gdtoolkit_4 # Godot toolkit, provides `gdformat`
      gimp
      glxinfo
      godot-with-libs
      gparted
      gpick
      handlr
      htmlq
      httpie
      httrack
      imhex
      inxi
      jstest-gtk # Bluetooth controller tester
      unstable.just
      unstable.kitty
      kopia
      unstable.lazygit
      ldns # drill - better(?) dig
      libreoffice
      lolcat
      lsd
      maim # Screenshot tool
      mangohud
      mimeo
      multitail
      cinnamon.nemo
      neofetch
      nerdfonts
      nextcloud-client
      nix-direnv
      nmap
      unstable.nushell
      unstable.obsidian
      oh-my-posh
      openfortivpn
      parallel
      pavucontrol
      pcmanfm
      polybarFull
      protonup-qt # Manage Steam games & ProtonGE versions
      pulseaudio # For `pactl` and audio sink switching
      qpwgraph # Pipewire connection graph
      quickemu
      qutebrowser
      razer-battery-tray
      remmina
      ripgrep-all
      rmlint
      rustdesk-flutter
      shotgun # Screenshot tool
      shutter
      spectacle
      spice-gtk
      sshpass
      stalonetray # Used to hack tray icons into my eww bar
      unstable.telegram-desktop
      tesseract5
      unstable.thunderbird-bin
      tldr # Simplified man pages
      udiskie
      unclutter-xfixes
      unstable.ventoy-bin-full # or `ventoy-bin`?
      whois
      wireguard-tools
      xorg.xhost
      xorg.xkill
      xournalpp
      xsecurelock
      xss-lock
      xorg.xwininfo
      unstable.zoxide
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
    "xsecurelock-dimmer" = {
      source = "${pkgs.xsecurelock}/libexec/xsecurelock/dimmer";
      target = ".local/bin/xsecurelock-dimmer";
    };

    #"proton-ge" =
    #  let
    #    version = "7-42";
    #  in
    #  {
    #    source = pkgs.fetchzip {
    #      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${version}/GE-Proton${version}.tar.gz";
    #      sha256 = "sha256-lTd/NX/VtBQCO/feunBYNp+HqbQVB+8gRAszTb+Pktk=";
    #    };
    #    target = ".steam/root/compatibilitytools.d/GE-Proton${version}";
    #  };
  };

  xdg.configFile = {
    # Enable `virsh` to access the local machines
    "libvirt/libvirt.conf".text = ''
      uri_default = "qemu:///system"
    '';
  };

  programs.script-directory = {
    enable = true;
    settings = {
      SD_ROOT = "${config.home.homeDirectory}/.sd";
      # TODO: neovim has been wrapped to allow NIX_LD stuff. Find a way to use it here => Maybe using an overlay that provides `nvim-ld` or even overrides `neovim` package?
      #SD_EDITOR = "${pkgs.neovim}/bin/nvim";
      SD_EDITOR = "nvim";
      SD_CAT = "${pkgs.bat}/bin/bat";
    };
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
