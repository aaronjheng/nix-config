{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crush-bin";
  version = "0.79.1";

  src = fetchurl {
    url = "https://github.com/charmbracelet/crush/releases/download/v${finalAttrs.version}/crush_${finalAttrs.version}_Darwin_arm64.tar.gz";
    hash = "sha256-hQp/r1WProRHGb+AdrFrECjOAUAIs4GwfVa1m5m6qzc=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  dontConfigure = true;
  dontBuild = true;
  dontGzipMan = true;
  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    install -Dm755 crush $out/bin/crush

    installShellCompletion --cmd crush \
      --bash completions/crush.bash \
      --fish completions/crush.fish \
      --zsh completions/crush.zsh

    installManPage manpages/crush.1.gz

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Glamourous AI coding agent for your favourite terminal";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "crush";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
