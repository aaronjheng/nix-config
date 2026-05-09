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
    rev = "4a1c687a6c11937f0ac5e3d55246d48a10394d96";
    hash = "sha256-sYKLybovH+iZbLxBah+hC5cAYQvoQ7NgnQJ9So+gKSA=";
  };

  vendorHash = "sha256-fQXCkjAw2vs4dXOofTD9jweXmVsMhvNVslMjmDeC+Pg=";

  ldflags = [
    "-s"
  ];

  meta = {
    homepage = "https://github.com/aaronjheng/redis-cli";
    description = "Redis command-line interface tool";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      aaronjheng
    ];
    mainProgram = "redis";
  };
})
