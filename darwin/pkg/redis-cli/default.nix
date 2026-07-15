{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "redis-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "redis-cli";
    rev = "13ce154865823907a2ba45b139ebd7754802189a";
    hash = "sha256-JYk8AAWTKGthp1VHC1/xI7gQ4XJtHci0aDgf5pVEaC8=";
  };

  vendorHash = "sha256-AyUJC7a45nLDLbNo7zf5yQELdCg10ArCypeHa3p2UXU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd redis \
      --bash <($out/bin/redis completion bash) \
      --fish <($out/bin/redis completion fish) \
      --zsh <($out/bin/redis completion zsh)
  '';

  meta = {
    homepage = "https://github.com/aaronjheng/redis-cli";
    description = "Redis command-line interface tool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "redis";
  };
})
