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
    rev = "fe506780af91909faa0d3246275f057826e53c15";
    hash = "sha256-fQECee4RA+jLwH6wJl09AyY5ygCov2WuufHHdAKsr1c=";
  };

  vendorHash = "sha256-X58NS+MAiPP72ejUE7BhBxueplqDhQiQhBz9jCKWCiE=";

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
