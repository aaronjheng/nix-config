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
    rev = "78bb388c1ed3da3e9f37b96005fbf5abdb6931e3";
    hash = "sha256-wwukow7cIu4MXVzJDNT4toZkgcnKmp7Du2cL5cwo3EI=";
  };

  vendorHash = "sha256-wpxwgnlO/y5oUk6Yypq0jPcEJ4SZF6jLYTNF4PB6Zc4=";

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