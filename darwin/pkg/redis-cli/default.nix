{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  go_1_27,
}:

(buildGoModule.override { go = go_1_27; }) (finalAttrs: {
  pname = "redis-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "redis-cli";
    rev = "87a853d6ab8c081d99bd0f6efe5363a59ebb3ccb";
    hash = "sha256-bAP4qYhgMknxW3bQ75aVWY2d7Aonjrzo7OW2brF09zc=";
  };

  vendorHash = "sha256-PVC/ilUX8nUlSmDgbYnRj66qxgXjDFKdYRRzzreIQOw=";

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
