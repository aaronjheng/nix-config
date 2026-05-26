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
    rev = "c4dd96758fda1a03dd21e119ce48f9a0d5d88dc8";
    hash = "sha256-gPhc0Mycw54Z5BWI78sXxhA6K+MaYi56fwVYjHT4sHQ=";
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
