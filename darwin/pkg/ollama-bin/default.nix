{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ollama-bin";
  version = "0.32.0";

  src = fetchurl {
    url = "https://github.com/ollama/ollama/releases/download/v${finalAttrs.version}/ollama-darwin.tgz";
    hash = "sha256-OxKknGxMuv1/+6XMumDL+AJ0zcIu6j6tecZGq6iIF0w=";
  };

  unpackPhase = ''
    runHook preUnpack

    mkdir ollama
    tar xzf $src -C ollama

    runHook postUnpack
  '';

  sourceRoot = "ollama";

  dontStrip = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    install -D ollama $out/bin/ollama
    install -D -t $out/lib/ollama llama-server llama-quantize

    mkdir -p $out/lib/ollama
    find . \( -name '*.dylib' -o -name 'mlx_*' \) -exec cp -r {} $out/lib/ollama/ \;

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/ollama \
      --prefix DYLD_LIBRARY_PATH : "$out/lib/ollama"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/ollama";
  versionCheckProgramArgs = [ "--version" ];

  meta = {
    description = "Get up and running with large language models locally";
    homepage = "https://ollama.com/";
    changelog = "https://github.com/ollama/ollama/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ aaronjheng ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "ollama";
  };
})
