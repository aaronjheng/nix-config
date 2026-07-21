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
    rev = "eb45065b5b25a66d0891eee476f4eb7446d3de11";
    hash = "sha256-p6WFqdJgubKpMypMVGInSVg1Q4WRhxQwTCrlUfSJtZ8=";
  };

  vendorHash = "sha256-5uJMbIXE+0ygOCVdBdcu3WNubXIoCtbCjB6pz+SiqsI=";

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
