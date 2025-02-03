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

	nix-build '<darwin>' -A darwin-rebuild
	./result/bin/darwin-rebuild switch -I darwin-config={{justfile_directory()}}/darwin/configuration.nix
	rm -rf ./result

rebuild-darwin:
	darwin-rebuild switch -I darwin-config={{justfile_directory()}}/darwin/configuration.nix

update-darwin:
	sudo nix-channel --update

uninstall-darwin:
	darwin-uninstaller
