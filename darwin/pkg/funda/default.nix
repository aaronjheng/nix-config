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
    rev = "a9d22e74568c6d21810059fabb873e664e2ef2c7";
    hash = "sha256-GprBmzMeDPE0XpGOPpOIX7ZlFeIcnqbcpk4iWu1CYLk=";
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
