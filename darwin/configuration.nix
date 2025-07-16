{
  pkgs,
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
  };

  security.sudo.extraConfig = ''
    %admin       ALL=(ALL) NOPASSWD: ALL

    Defaults:%admin env_keep += "HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY"
    Defaults:%admin env_keep += "http_proxy https_proxy all_proxy no_proxy"
    Defaults:%admin env_keep += "EDITOR VISUAL"
    Defaults:%admin env_keep += "TERMINFO TERMINFO_DIRS"
  '';

  fonts.packages = with pkgs; [
    (callPackage ./pkg/lucida-console.nix { })
    vista-fonts
  ];

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

  environment.profiles = [
    "$HOME/.local/state/nix/profile"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableGlobalCompInit = false;
    enableSyntaxHighlighting = true;
    enableFzfCompletion = true;
    interactiveShellInit = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';
  };

  services.openssh.enable = true;

  users.users.aaron.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOX8ktOiPEPgsSBqx8OKMSYJ7opYbQe34aT0wmwfyUiX aaron@aarons"
  ];

  users.users.aaron.packages = with pkgs; [
    _7zz
    atuin
    awscli2
    bat
    bind
    broot
    btop
    buf
    chezmoi
    # clash-rs
    (callPackage ./pkg/clash-rs { })
    claude-code
    codex
    container
    cue
    dust
    duf
    fd
    ffmpeg_6
    gemini-cli
    gh
    go
    gojq
    golangci-lint
    goreman
    just
    k6
    kubectl
    mitmproxy
    # mysql-shell
    nix-update
    nixd
    nixfmt-rfc-style
    nixpkgs-review
    oath-toolkit
    pnpm_9
    poppler-utils
    postgresql
    ruff
    trunk-io
    teleport
    temporal-cli
    uv
    vault
    wget2
    wire
    xh
    zig
    zig-shell-completions
    zls
    zoxide
  ];

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    casks = [
      "appcleaner"
      "cursor"
      "ghostty"
      "iina"
      "keka"
      "obsidian"
      "openvpn-connect"
      "pictogram"
      "postman"
      "raycast"
      "rectangle"
      "typora"
      "utm"
      "visual-studio-code"
      "wireshark"
    ];
  };
}
