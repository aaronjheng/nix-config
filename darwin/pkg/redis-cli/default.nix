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
    rev = "e7ad5672f3bdbabe9168bcfd907d4288e144768d";
    hash = "sha256-fcrcRWWBNQtYvvUDwfu3bY4TPfib6mAdwx0QmcJGQNs=";
  };

  vendorHash = "sha256-PNG2938psiw6NCWvS3h1iuQLVEHLztosWOYPKFzRQ8k=";

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
