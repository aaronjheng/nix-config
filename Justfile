set dotenv-load

install-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  		sh -s -- install

uninstall-nix:
	/nix/nix-installer uninstall

setup-darwin:
	suod nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
	sudo nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
	sudo nix-channel --update

	sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin

	nix-build '<darwin>' -A darwin-rebuild
	./result/bin/darwin-rebuild switch -I darwin-config={{justfile_directory()}}/darwin/configuration.nix

rebuild-darwin:
	sudo mkdir -p /etc/nix-darwin
	sudo cp -f {{justfile_directory()}}/darwin/configuration.nix /etc/nix-darwin/configuration.nix
	darwin-rebuild switch -I darwin-config=/etc/nix-darwin/configuration.nix

update-darwin:
	sudo nix-channel --update
