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
    rev = "88bd411de870a1b1d34456d7414b72b2bfc3d405";
    hash = "sha256-dMzl5+ItFXlGouDORzbAuLkkQKNy4LLDHrg/PdUsqy0=";
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
