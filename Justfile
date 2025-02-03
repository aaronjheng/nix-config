set dotenv-load := true

install-nix:
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

uninstall-nix:
    sudo /nix/nix-installer uninstall

[macos]
install-brew:
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

[macos]
uninstall-brew:
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

[macos]
show-darwin-variant:
    @echo "Darwin variant: {{ env('DARWIN_VARIANT') }}"

[macos]
confirm-darwin-variant:
    #!/usr/bin/env bash
    echo "Darwin variant: {{ env('DARWIN_VARIANT') }}"
    read -p "Are you sure you want to continue? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 1; fi

[macos]
setup-darwin: show-darwin-variant
    #!/usr/bin/env bash
    sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
    sudo nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
    sudo nix-channel --update

    sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
    sudo cp -r darwin/ /etc/nix-darwin

    nix-build '<darwin>' -A darwin-rebuild
    ./result/bin/darwin-rebuild switch -I darwin-config=/etc/nix-darwin/configuration.nix
    rm -rf ./result

[macos]
rebuild-darwin: show-darwin-variant
    #!/usr/bin/env bash
    variant="{{ env('DARWIN_VARIANT') }}"
    sudo cp -r darwin/ /etc/nix-darwin
    darwin-rebuild switch -I darwin-variant={{ justfile_directory() }}/darwin/variant/${variant}.nix

[macos]
update-darwin:
    sudo nix-channel --update

[macos]
uninstall-darwin:
    darwin-uninstaller
