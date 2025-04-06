#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gojq xh wget2 curl gnupg gh

PROJECT_ROOT="$(
	cd "$(dirname "$0")/.."
	pwd
)"
pushd "${PROJECT_ROOT}/bootstrap" 1>/dev/null

echo "Generating bootstrap files"

GITHUB_TOKEN=$(gh auth token)

chezmoi_version=$(xh --auth-type bearer --auth ${GITHUB_TOKEN} get https://api.github.com/repos/twpayne/chezmoi/releases/latest | gojq -r '.tag_name' | sed 's/^v//')
clash_version=$(xh --auth-type bearer --auth ${GITHUB_TOKEN} get https://api.github.com/repos/Watfaq/clash-rs/releases/latest | gojq -r '.tag_name' | sed 's/^v//')
just_version=$(xh --auth-type bearer --auth ${GITHUB_TOKEN} get https://api.github.com/repos/casey/just/releases/latest | gojq -r '.tag_name' | sed 's/^v//')

readonly chezmoi_version clash_version just_version

wget2 -O chezmoi "https://github.com/twpayne/chezmoi/releases/download/v${chezmoi_version}/chezmoi-darwin-arm64"

chmod +x chemoi

wget2 -O clash "https://github.com/Watfaq/clash-rs/releases/download/v${clash_version}/clash-aarch64-apple-darwin"

curl -L "https://github.com/casey/just/releases/download/${just_version}/just-${just_version}-aarch64-apple-darwin.tar.gz" | tar -xz

wget2 -O google-chrome.dmg https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg

cp -f ~/.config/clash/config.yaml clash.yaml
cp -f ~/.config/chezmoi/chezmoi.toml chezmoi.toml

# GnuPG
gpg -a --export >gnupg-public-keys.asc

gpg -a --export-secret-keys >gnupg-private-keys.asc

gpg --export-ownertrust >gnupg-ownertrust

# SSH

cp ~/.ssh/id_ed25519.pub .
cp ~/.ssh/id_ed25519 .

popd 1>/dev/null
