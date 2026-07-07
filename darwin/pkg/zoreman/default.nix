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
    rev = "41ba7fe184c2707e7544195996a0df5d796a0755";
    hash = "sha256-kXkU2baHDxlFoKu4R/PAk7fH4C2c3833xG2a8Yg80L4=";
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
