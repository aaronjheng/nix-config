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
    extra-trusted-users = [
      "aaron"
    ];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
  };

  security.sudo.extraConfig = ''
    %admin       ALL=(ALL) NOPASSWD: ALL

    Defaults:%admin env_keep += "HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY"
    Defaults:%admin env_keep += "http_proxy https_proxy all_proxy no_proxy"
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

}
