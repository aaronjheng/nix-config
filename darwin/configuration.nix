{ config, pkgs, ... }:

{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  nix.useDaemon = true;

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
    Defaults:%admin env_keep += "TERMINFO TERMINFO_DIRS"
  '';

  environment.shells = with pkgs; [
    zsh
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  environment.profiles = [
    "$HOME/.local/state/nix/profile"
  ];

  programs.zsh.enable = true;
  programs.zsh.shellInit = ''

    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';

  services.nix-daemon.enable = false;

  homebrew = {
    enable = true;
    casks = [
      "appcleaner"
      "obsidian"
      "typora"
      "chatgpt"
      "openvpn-connect"
      "utm"
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

  users.users.aaron.packages =
    with pkgs;
    [
      atuin
      awscli2
      bat
      bind
      broot
      btop
      buf
      chezmoi
      cue
      curl
      delta
      dust
      duf
      fd
      gcc
      gh
      git
      gnupg
      go
      gojq
      golangci-lint
      goreman
      inetutils
      just
      k6
      kubectl
      lsof
      mitmproxy
      (mysql-shell.override {
        stdenv = llvmPackages_18.stdenv;
      })
      nix-zsh-completions
      nix-update
      nixd
      nixfmt-rfc-style
      nixpkgs-review
      oath-toolkit
      pnpm
      poetry
      postgresql
      tmux
      trunk-io
      temporal-cli
      uv
      vault
      vim
      wget2
      xh
      zig
      zig-shell-completions
      zls
      zoxide
      zsh-completions
    ]
    ++ [
      iproute2mac
    ];
}
