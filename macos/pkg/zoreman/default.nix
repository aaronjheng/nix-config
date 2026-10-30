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
    rev = "877cd2ef913b37a6e1873dcc62c5f521f1651a45";
    hash = "sha256-x+nARy+3rOa2d5O6Zr4EQ+Ek1qX/Xlofplu4e2j7Bow=";
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
