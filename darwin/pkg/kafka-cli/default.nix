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
    rev = "31d405db2880e427248e12236eb7b5f0415ed94b";
    hash = "sha256-54gGnu8w0jHHeQ7S0AIuq7jcN57YQriKNGY+6CAlS5M=";
  };

  vendorHash = "sha256-MfBVNffDwmJB7zJDKYu+8kvUMLwZiSekWdlZ/yqNnis=";

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
