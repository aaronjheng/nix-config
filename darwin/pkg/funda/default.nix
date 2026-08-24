{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_27,
}:

(buildGoModule.override { go = go_1_27; }) (finalAttrs: {
  pname = "funda";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "funda";
    rev = "413659ed541c28bc51454cbe158821a937073725";
    hash = "sha256-XlhaQKltiSuARibQr7MTEc0wxnE695aEOWZzW3KZ4Ao=";
  };

  vendorHash = "sha256-0IcwkgEaaXCSlziUm6fbcAlDakYDwkJ/Webkfo94ZV8=";

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
