{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "redis-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "redis-cli";
    rev = "55e86d816cdf93d597de81579e3700b11b7cb4bc";
    hash = "sha256-Lum2d6PigWcZnuLvzERiNy8S/hNmvEQxt8s7N6T8W9o=";
  };

  vendorHash = "sha256-PNG2938psiw6NCWvS3h1iuQLVEHLztosWOYPKFzRQ8k=";

  ldflags = [
    "-s"
  ];

  meta = {
    homepage = "https://github.com/aaronjheng/redis-cli";
    description = "Redis command-line interface tool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "redis";
  };
})
