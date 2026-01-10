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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "zoreman";
    rev = "96dade2647359118cc995cfc974836db59bdd9cf";
    hash = "sha256-sVXEzyDR1sZkAIGKYgCQbeMnQRREBx62NRBFTNF/5Cc=";
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
    platforms = lib.platforms.darwin;
    mainProgram = "zoreman";
  };
})
