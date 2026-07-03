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
    rev = "bba7da7e99fcdb343c12945c463e05b2cbfa2a76";
    hash = "sha256-WAre7FJc/W6PLqxcU93mXothd+ZWw/X3skEd5VwS84w=";
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
