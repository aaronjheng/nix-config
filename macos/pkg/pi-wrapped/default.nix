# pi-coding-agent is installed via nix, so `npm` is not on PATH. Wrap the
# upstream package *unchanged* (so its binary cache is reused and this
# wrapper stays a seconds-long build) to expose the npm from the nodejs in
# pi's runtime closure. Lets pi resolve its default `npmCommand` (plain
# `npm` from PATH) without a hardcoded store path in
# ~/.pi/agent/settings.json. Appended (not prepended) to PATH, matching
# upstream's resolution of earendil-works/pi#10519: a caller-provided
# node/npm (mise, nvm, ...) still wins in tool shells; pi's own is the
# fallback.
#
# The zsh completion is shipped in the same output, so this single package
# is all that has to be listed; nix-darwin links share/zsh from installed
# packages into zsh's fpath.
{
  lib,
  installShellFiles,
  makeWrapper,
  nodejs,
  pi-coding-agent,
  runCommand,
}:

runCommand "pi-wrapped" {
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  meta = {
    description = "pi-coding-agent with npm on PATH and zsh completion";
    mainProgram = "pi";
  };
} ''
  makeWrapper ${pi-coding-agent}/bin/pi $out/bin/pi \
    --suffix PATH : ${lib.makeBinPath [ nodejs ]}

  installShellCompletion --zsh --name _pi ${./pi.zsh-completion}
''
