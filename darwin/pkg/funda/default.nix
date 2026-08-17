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
    rev = "c11c2a84107ec0fd9ad690ee2dbbf2b73389a495";
    hash = "sha256-71WxprugbJkcT+7u4eyj106XZ4YgDMZNgT2x61PnSh0=";
  };

  vendorHash = "sha256-tJBy93r/CaD5JP6SEUjRa7GAUbYYKUwJxIiAH9RSzRg=";

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
