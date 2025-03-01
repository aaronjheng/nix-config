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

  nix.settings = {
    experimental-features = [
      "nix-command"
    ];
    trusted-users = [
      "@admin"
    ];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
  };

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
    vistafonts
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
    less
    lsof
    rsync
    tmux
    vim
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

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    casks = [
      "appcleaner"
      "obsidian"
      "typora"
      "openvpn-connect"
      "figma"
      "pictogram"
      "visual-studio-code"
      "ghostty"
      "postman"
      "wireshark"
      "iina"
      "raycast"
      "keka"
      "rectangle"
    ];
  };

  users.users.aaron.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOX8ktOiPEPgsSBqx8OKMSYJ7opYbQe34aT0wmwfyUiX aaron@aarons"
  ];

  users.users.aaron.packages = with pkgs; [
    atuin
    awscli2
    bat
    bind
    broot
    btop
    buf
    chezmoi
    cue
    dust
    duf
    fd
    gh
    go
    gojq
    golangci-lint
    goreman
    iproute2mac
    just
    k6
    kubectl
    mitmproxy
    mysql-shell
    nix-zsh-completions
    nix-update
    nixd
    nixfmt-rfc-style
    nixpkgs-review
    oath-toolkit
    pnpm_9
    poetry
    poppler-utils
    postgresql
    trunk-io
    temporal-cli
    uv
    vault
    wget2
    xh
    zig
    zig-shell-completions
    zls
    zoxide
    zsh-completions
  ];
}
