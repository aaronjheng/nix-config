{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_15,
  testers,
}:
let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zoreman";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "zoreman";
    rev = "4933ee6472f463015fe856c82929fd95c50b3517";
    hash = "sha256-12/UM1DhhmA5uOl7O+yQOoNl0qNTiWZHCPyoBxXKiZY=";
  };

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
