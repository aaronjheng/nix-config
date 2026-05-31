{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "funda";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "funda";
    rev = "6bd49b8ed7068d78542c1feb030f3d6d20d74073";
    hash = "sha256-tOe4rU0EP29HFPpr2yEOcNoFa9bR+fzVgydXJaGXd3o=";
  };

  vendorHash = "sha256-u5JI5dObJZoaANIOCrBAcYs4gLj/PogcWIzPfdG+vxU=";

  ldflags = [
    "-s"
  ];

  meta = {
    homepage = "https://github.com/aaronjheng/funda";
    description = "Terminal UI tool for tracking and viewing fund valuation data";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "funda";
  };
})
