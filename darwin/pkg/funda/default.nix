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
    rev = "d9e9d1da30071aa42596f32320efa6941d89a12d";
    hash = "sha256-f5fdbZ8QMJef6W5VU2OP2/jv+TKXB2/BCfoZXdk5ufM=";
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
