{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kafka-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "kafka-cli";
    rev = "1afe107d0817c40c735531fd66182b418569ae39";
    hash = "sha256-4LhaqoFw8kDyQ6YrwaL8qPeJu3fK7zGpeQoqCMh8jyg=";
  };

  vendorHash = "sha256-nbjhrlNyI6ySWPtUt88qpgV+q3yiUNEI6/rrZ5DNiRY=";

  excludedPackages = [
    "test"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kafka \
      --bash <($out/bin/kafka completion bash) \
      --fish <($out/bin/kafka completion fish) \
      --zsh <($out/bin/kafka completion zsh)
  '';

  meta = {
    homepage = "https://github.com/aaronjheng/kafka-cli";
    description = "Lightweight command-line tool for managing Apache Kafka clusters";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "kafka";
  };
})
