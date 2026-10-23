{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_17,
  testers,
  installShellFiles,
}:
let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zoreman";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "zoreman";
    rev = "4b5d41678bd4decd2bd5363d220e218cfc882d67";
    hash = "sha256-wWUnveKQCRo5UHr+PxBkfi4UVlzHyjvKqZpkHdBcic8=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-XB3NP8oTiqRO4dV5ROlQp7GaplZPpOqS5plnmCO8Djw=";
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
