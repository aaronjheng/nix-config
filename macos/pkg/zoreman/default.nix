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
    rev = "dfcd7f820c9849dd1e62bd85cd0b76ddd3457fc6";
    hash = "sha256-VDV8SxLZtK9VPb5jAjfWUG2Q48TZQymmYCvt0ngUQy8=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-3KpDCjZlrPoGfjLhFxbtiyqlWtw2jRv/JYIQ+2yTqWo=";
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
