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
    rev = "2010815c3cb0f21cd9f5d2cdaf4295cff81ec441";
    hash = "sha256-RapSHfka1OaPRBfqSowopJvTpTY3T+dduDP+fT7lbMQ=";
  };

  vendorHash = "sha256-6diwmvgu16fW3je2TM9NLY9YIde1GK0XcGx69dkEMWw=";

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
