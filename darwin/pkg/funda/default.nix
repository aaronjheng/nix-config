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
    rev = "1c997ce61791bee3b7fda740e6020a76ad9ae805";
    hash = "sha256-pQGFswi62OXFm9Dl8FUI+XNjgUJ/JeHXy152Zuew+mA=";
  };

  vendorHash = "sha256-NqgazMOJeGoTRNuzZZPpWvcVsHMwi8aZ/XmRdh8qwq0=";

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
