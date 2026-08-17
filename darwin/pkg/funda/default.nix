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
    rev = "1a94eeb48f88b38651395802a9d97bedf852eafb";
    hash = "sha256-Y7LIsrEgEBdk9MrTh0c5XDbie0JNpJzaTlSgC1deSGA=";
  };

  vendorHash = "sha256-ERixFbDbBXiBMCOnnioEfchfWQ+SRJVECLAqof5/KxY=";

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
