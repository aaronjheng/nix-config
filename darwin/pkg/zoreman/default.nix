{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_16,
  testers,
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
    rev = "7b1afe5f0b18240d5bd8be321ef5665a874084d4";
    hash = "sha256-3ok+goPiBUgsFrBhdbQ5DBfKdMnSMXbMHZ16XJ1+V7Q=";
  };

  zigBuildFlags = [
    "--system"
    (callPackage ./deps.nix { })
  ];

  nativeBuildInputs = [
    zig.hook
  ];

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
