{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    <darwin-variant>
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  nix.enable = false;

  nixpkgs.config = {
    allowUnfree = true;
    allowInsecurePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "openclaw"
      ];
  };

  security.sudo.extraConfig = ''
    %admin       ALL=(ALL) NOPASSWD: ALL

    Defaults:%admin env_keep += "HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY"
    Defaults:%admin env_keep += "http_proxy https_proxy all_proxy no_proxy"
    Defaults:%admin env_keep += "EDITOR VISUAL"
    Defaults:%admin env_keep += "TERMINFO TERMINFO_DIRS"
  '';

  environment.etc = {
    "resolver/stg.g123.jp.private".text = ''
      domain stg.g123.jp.private
      search stg.g123.jp.private
      nameserver 10.0.0.2
    '';
  };

  environment.shells = with pkgs; [
    zsh
  ];

  environment.systemPackages = with pkgs; [
    curl
    delta
    git
    gnupg
    inetutils
    iproute2mac
    less
    lsof
    rsync
    tmux
    vim
    zsh-completions
    zsh-autosuggestions
  ];

  fonts.packages = with pkgs; [
    (callPackage ./pkg/vista-fonts { })
    noto-fonts-cjk-sans
  ];

  launchd.daemons.nix-collect-garbage = {
    serviceConfig = {
      ProgramArguments = [
        "/nix/var/nix/profiles/default/bin/nix-collect-garbage"
        "--delete-older-than"
        "3d"
      ];

      StartCalendarInterval = {
        Hour = 0;
        Minute = 1;
      };

      StandardOutPath = "/var/log/nix-collect-garbage.log";
      StandardErrorPath = "/var/log/nix-collect-garbage.log";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableGlobalCompInit = false;
    enableSyntaxHighlighting = true;
    enableFzfCompletion = true;
    enableAutosuggestions = true;
  };

  services.openssh.enable = true;

  users.users.aaron.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOX8ktOiPEPgsSBqx8OKMSYJ7opYbQe34aT0wmwfyUiX aaron@aarons"
  ];

  users.users.aaron.packages = with pkgs; [
    _7zz
    amp-cli
    atuin
    awscli2
    bat
    bind
    broot
    btop
    buf
    chezmoi
    clash-rs
    claude-code
    codex
    container
    cue
    cursor-cli
    # diffoscope
    duckdb
    dust
    duf
    fd
    ffmpeg
    gemini-cli
    gh
    ghostscript
    github-copilot-cli
    go
    gojq
    golangci-lint
    goreman
    imagemagick
    jujutsu
    just
    just-lsp
    k6
    kubectl
    kubectl-ktop
    mitmproxy
    mysql-shell
    nmap
    nix-update
    nixd
    nixfmt
    oath-toolkit
    openclaw
    pnpm_9
    postgresql
    python3
    python3Packages.ipython
    ruff
    socat
    teleport
    temporal-cli
    unar
    uv
    viu
    wire
    xh
    zig
    zig-shell-completions
    (callPackage ./pkg/zoreman { })
    zon2nix
    zoxide
  ];

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    casks = [
      "appcleaner"
      "beekeeper-studio"
      "ghostty"
      "iina"
      "keka"
      "obsidian"
      "openvpn-connect"
      "postman"
      "ppsspp-emulator"
      "raycast"
      "rectangle"
      "redis-insight"
      "typora"
      "utm"
      "visual-studio-code"
      "wireshark-app"
    ];
  };
}
