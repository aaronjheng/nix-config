{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  go_1_27,
}:

(buildGoModule.override { go = go_1_27; }) (finalAttrs: {
  pname = "kafka-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aaronjheng";
    repo = "kafka-cli";
    rev = "ff7283c64164f1509f1cc2ab1242148610450078";
    hash = "sha256-tAMATiqPKvi8NH//HGt3r7rNtowCWwjktqQaP+ojYZQ=";
  };

  vendorHash = "sha256-PUCsrNq5RZ8sqZeYY/cDpg7bI/dn4gPbzIaKPJBrbjo=";

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