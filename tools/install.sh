#!/usr/bin/env bash

PROJECT_ROOT="$(
	cd "$(dirname "$0")/.."
	pwd
)"
pushd "${PROJECT_ROOT}/bootstrap" 1>/dev/null

# Proxy
function proxy_on() {
	export HTTP_PROXY=http://127.0.0.1:7890
	export HTTPS_PROXY=http://127.0.0.1:7890
	export ALL_PROXY=socks5://127.0.0.1:7890
	export NO_PROXY=localhost,internal.domain,.local,example.dev,.example.dev,10.0.0.1/8,127.0.0.1/24,192.168.0.1/16

	export http_proxy=http://127.0.0.1:7890
	export https_proxy=http://127.0.0.1:7890
	export all_proxy=socks5://127.0.0.1:7890
	export no_proxy=localhost,internal.domain,.local,example.dev,.example.dev,10.0.0.1/8,127.0.0.1/24,192.168.0.1/16
}

function system_proxy_setup() {
	host="127.0.0.1"
	port="7890"

	networksetup -setsecurewebproxy 'Wi-Fi' "${host}" "${port}"
	networksetup -setwebproxy 'Wi-Fi' "${host}" "${port}"
	networksetup -setsocksfirewallproxy 'Wi-Fi' "${host}" "${port}"
	networksetup -setproxybypassdomains 'Wi-Fi' 'localhost' 'internal.domain' '*.local' 'example.dev' '*.example.dev' '10.*' '127.0.0.*' '192.168.*'
}

proxy_on

system_proxy_setup

export NIXPKGS_ALLOW_INSECURE=1
export NIXPKGS_ALLOW_UNFREE=1

# sudo
sudo tee /etc/sudoers.d/admin <<"ADMIN"
%admin       ALL=(ALL) NOPASSWD: ALL

Defaults:%admin env_keep += "HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY"
Defaults:%admin env_keep += "http_proxy https_proxy all_proxy no_proxy"
ADMIN

# PATH
export PATH="${PROJECT_ROOT}/bootstrap:${PATH}"

# Google Chrome
hdiutil attach google-chrome.dmg

cp -R /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/

hdiutil detach /Volumes/Google\ Chrome

# Xcode Command Line Tools
xcode-select --install

# GnuPG keys
gpg --import gnupg-public-keys.asc
gpg --import gnupg-private-keys.asc
gpg -K
gpg -k
gpg --import-ownertrust gnupg-ownertrust

# SSH keys
cp -f id_ed25519.pub ~/.ssh/
cp -f id_ed25519 ~/.ssh/

chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# dotfiles
chezmoi init --ssh --apply --verbose aaronjheng

pushd "${PROJECT_ROOT}" 1>/dev/null

# Homebrew
just install-brew

# Nix
just install-nix

# Nix Darwin
just setup-darwin

popd 1>/dev/null

sudo rm -rf /etc/sudoers.d/admin

popd 1>/dev/null
