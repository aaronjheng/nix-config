{
  lib,
  stdenv,
  fetchFromGitHub,
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
    rev = "135ebe949be528ab36d9c751d8434feac69cd1d5";
    hash = "sha256-2pmkDBTXqBX8QZXKDXz6f2kwf7FfKmCDLVR5hgfgwwo=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-dNd20PL0VzOtTZRIOjMj4NMXOaSA31tV18e8T51+wHw=";
  };

  postConfigure = ''
    ln -sf ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

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
