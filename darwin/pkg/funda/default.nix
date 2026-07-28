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
    rev = "61a1e44ffdbe4d6dc8fbf9cdbdd7e9b6b3c077c0";
    hash = "sha256-phCcjQDwEEtcrUD1ik8+qowRdvoyY0nNj0Qn/Dukv70=";
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
