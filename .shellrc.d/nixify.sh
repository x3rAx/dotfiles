nixify() {
    if ! command -v curl >/dev/null; then echo >&2 'ERROR: Dependency `curl` is missing'; return 1; fi
    if ! command -v jq >/dev/null; then echo >&2 'ERROR: Dependency `jq` is missing'; return 1; fi

    if [ -e ./.envrc ] && grep -Pq '^use nix$' .envrc; then
        echo >&2 'File `.envrc` already exists and it has a line containing `use nix`'
        return 1
    fi
    echo >&2 "Activating nix env"
    touch .envrc
    if [ "$(wc -l <.envrc)" -eq 0 ]; then
        # Write first line so `sed` can insert
        echo '' >>.envrc
    fi
    # Insert `use nix` in first line
    sed -i '1 i\use nix' .envrc
    direnv allow
    if [[ -e shell.nix ]]; then
        echo >&2 'File `shell.nix` already exists'
        return 1
    fi
    if [[ -e default.nix ]]; then
        echo >&2 'File `default.nix` already exists'
        return 1
    fi

    channel_version="$(nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version')"
    channel_version="${channel_version//\"/}"
    channel_commit="$(echo "$channel_version" | cut -d'.' -f4)"
    commit_info="$(curl -s https://api.github.com/repos/NixOS/nixpkgs/commits/${channel_commit})"
    commit_hash="$(echo "$commit_info" | jq -r '.sha')"
    commit_date="$(echo "$commit_info" | jq -r '.commit.committer.date')"

    cat > shell.nix <<EOF
let
  # Pinned nixpkgs, deterministic. Last updated: ${commit_date}.
  # (The \`nixpkgs\` channel that was used when generating this file is pinned here.,)
  pkgs = import (fetchTarball("https://github.com/NixOS/nixpkgs/archive/${commit_hash}.tar.gz")) {};

  # Specific NixOS release version. This is not the channel and does not get updated along with it.
  #pkgs = import (fetchTarball("https://github.com/NixOS/nixpkgs/archive/refs/tags/21.11.tar.gz")) {};

  # Rolling updates, not deterministic.
  #pkgs = import (fetchTarball("channel:nixpkgs-unstable")) {};
in pkgs.mkShell {
  # Programs and libraries used at *build*-time on the build host
  nativeBuildInputs = with pkgs; [
    bashInteractive
  ];
  # Programs and libraries used by the new derivation at *run*-time on the target host
  buildInputs = with pkgs; [
  ];

  # Certain Rust tools won't work without this
  # This can also be fixed by using oxalica/rust-overlay and specifying the rust-src extension
  # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela. for more details.
  #RUST_SRC_PATH = "\${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
EOF
    ${EDITOR:-vim} shell.nix
}

flakifiy() {
    if [ ! -e flake.nix ]; then
        nix flake new -t github:nix-community/nix-direnv .
    elif [ ! -e .envrc ]; then
        echo "use flake" > .envrc
        direnv allow
    fi
    ${EDITOR:-vim} flake.nix
}