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
    rev = "abf7a69118edcc9394bdc2f18a40455b1a0f4496";
    hash = "sha256-RUQ2HSVjvRkpiuzB27nqDL6ZbsyrDQCXi2NBKdBwJsY=";
  };

  vendorHash = "sha256-Qw/7wLioVFaLucA5fDem87qmO8rgvW8cVDzuSj8d390=";

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
