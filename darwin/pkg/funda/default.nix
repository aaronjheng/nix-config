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
    rev = "5b6aa2fc620b4815916eaa955480a4f7f4c2d98c";
    hash = "sha256-yQZdyyy0mLxTx9aJApM/kFFCsxpbWvn5wGclBy2UeSI=";
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
