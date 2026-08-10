{
  lib,
  stdenvNoCC,
  installShellFiles,
}:

stdenvNoCC.mkDerivation {
  pname = "pi-zsh-completion";
  version = "1.0.0";

  dontUnpack = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    installShellCompletion --zsh --name _pi ${./pi.zsh-completion}

    runHook postInstall
  '';

  meta = {
    description = "Zsh shell completion for pi (AI coding assistant)";
    homepage = "https://pi.dev/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aaronjheng ];
  };
}