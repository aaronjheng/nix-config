#!/usr/bin/env bash

set -eu

PROJECT_ROOT="$(
	cd "$(dirname "$0")/.."
	pwd
)"
pushd "${PROJECT_ROOT}/bootstrap" 1>/dev/null

echo "Proxy environemt variables"
echo ""

cat <<"PROXY"
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export ALL_PROXY=socks5://127.0.0.1:7890
export NO_PROXY=localhost,internal.domain,.local,example.dev,.example.dev,10.0.0.1/8,127.0.0.1/24,192.168.0.1/16

export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
export all_proxy=socks5://127.0.0.1:7890
export no_proxy=localhost,internal.domain,.local,example.dev,.example.dev,10.0.0.1/8,127.0.0.1/24,192.168.0.1/16
PROXY

echo ""

echo "Run clash"
echo ""
chmod +x ./clash && ./clash -f clash.yaml -d .

popd 1>/dev/null
