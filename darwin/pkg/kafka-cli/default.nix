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
    rev = "5bf25f95f7102b7b97b18cb8325c0c9fe94e7218";
    hash = "sha256-uhowdeGY4wqq6XJVlMxJmAvx6wAVLDPx/iIRm1Cyq8U=";
  };

  vendorHash = "sha256-RZg/DdkOcHyPXBet2wQPPz3lX6bKTkFn2ooPCnNOhTY=";

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
