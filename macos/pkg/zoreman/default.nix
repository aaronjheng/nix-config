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
    rev = "f2406f68681f9fa918359e8f56c692cced012a34";
    hash = "sha256-UoWMpOO/cad8NFW7Yz8UgIfue/y/Y3Soh8P+tIm7kDg=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-+c6F5Wee646mzgk8AEXvYqcF/HBGnUtFSQ3FS+80fFk=";
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
