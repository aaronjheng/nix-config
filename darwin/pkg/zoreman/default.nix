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
    rev = "6eb645e8066017467ebd0e6a2e2581a74cf1723a";
    hash = "sha256-AiwL2IZd7XOG/pthxYIeVeJY7LRw4TC2XGCB9Q++AFY=";
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
