{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  testers,
  installShellFiles,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zoreman";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "zoreman";
    rev = "0f188166671d50640a348f2b45ce0ff8229e026a";
    hash = "sha256-fZj2EOn/vBqQfTfDy+OOtxI9BIBG4yd+bkg0SmpiO48=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-3KpDCjZlrPoGfjLhFxbtiyqlWtw2jRv/JYIQ+2yTqWo=";
  };

  postConfigure = ''
    ln -sf ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    zig.hook
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zoreman \
      --bash <($out/bin/zoreman completion bash) \
      --zsh <($out/bin/zoreman completion zsh) \
      --fish <($out/bin/zoreman completion fish)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "zoreman version";
  };

  meta = {
    description = "Foreman clone in Zig";
    homepage = "https://github.com/aaronjheng/zoreman";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "zoreman";
  };
})
