set dotenv-load

install-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

uninstall-nix:
	sudo /nix/nix-installer uninstall

install-brew:
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

uninstall-brew:
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

setup-darwin:
	sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
	sudo nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
	sudo HTTPS_PROXY='http://127.0.0.1:7890' nix-channel --update

	sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
	sudo mkdir -p /etc/nix-darwin
	sudo cp -f {{justfile_directory()}}/darwin/configuration.nix /etc/nix-darwin/configuration.nix

	nix-build '<darwin>' -A darwin-rebuild
	./result/bin/darwin-rebuild switch -I darwin-config=/etc/nix-darwin/configuration.nix
	rm -rf ./result

rebuild-darwin:
	sudo mkdir -p /etc/nix-darwin
	sudo cp -f {{justfile_directory()}}/darwin/configuration.nix /etc/nix-darwin/configuration.nix
	darwin-rebuild switch

update-darwin:
	sudo nix-channel --update

uninstall-darwin:
	nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
