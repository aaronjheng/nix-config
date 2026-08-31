{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    <darwin-variant>
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  system.primaryUser = "aaron";

  documentation.enable = false;
  system.tools.darwin-uninstaller.enable = false;

  nix.enable = false;

  nixpkgs.config = {
    allowUnfree = true;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true; # Show all filename extensions
    ShowPathbar = true; # Show the path bar
  };

  # System Settings → Trackpad → Point & Click: enable tap to click.
  # macOS writes two keys when this toggle is clicked; mirror both so behavior
  # and the UI toggle display stay consistent:
  # - `Clicking` (AppleMultitouchTrackpad + Bluetooth domains): read by the driver;
  # - `com.apple.mouse.tapBehavior` (per-host ByHost domain): read by the UI toggle.
  system.defaults.trackpad.Clicking = true;
  system.defaults.CustomUserPreferences."~${config.system.primaryUser}/Library/Preferences/ByHost/.GlobalPreferences" = {
    "com.apple.mouse.tapBehavior" = 1;
  };

  # System Settings → Accessibility → Pointer Control → Trackpad Options:
  # enable dragging with the three-finger drag style
  system.defaults.trackpad = {
    Dragging = true; # Check "Enable dragging"
    DragLock = false; # Do not use the "with drag lock" style
    TrackpadThreeFingerDrag = true; # Dragging style: three finger drag
  };

  system.defaults.CustomUserPreferences."com.apple.GameController" = {
    bluetoothPrefsMenuLongPressAction = false;
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
  ];

  fonts.packages = with pkgs; [
    vista-fonts
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

  launchd.user.agents = {
    brew-cleanup = {
      serviceConfig = {
        ProgramArguments = [
          "/opt/homebrew/bin/brew"
          "cleanup"
          "--prune"
          "all"
        ];

        StartCalendarInterval = {
          Hour = 0;
          Minute = 1;
        };

        StandardOutPath = "/Users/aaron/Library/Logs/brew-cleanup.log";
        StandardErrorPath = "/Users/aaron/Library/Logs/brew-cleanup.log";
      };
    };

    chezmoi-update = {
      serviceConfig = {
        ProgramArguments = [
          "${pkgs.chezmoi}/bin/chezmoi"
          "update"
          "--apply"
        ];

        StartCalendarInterval = {
          Hour = 0;
          Minute = 1;
        };

        StandardOutPath = "/Users/aaron/Library/Logs/chezmoi-update.log";
        StandardErrorPath = "/Users/aaron/Library/Logs/chezmoi-update.log";
      };
    };

    clash = {
      serviceConfig = {
        LimitLoadToSessionType = [
          "Aqua"
          "Background"
          "LoginWindow"
          "StandardIO"
          "System"
        ];

        SoftResourceLimits = {
          NumberOfFiles = 65536;
        };

        ProgramArguments = [
          "${pkgs.clash-rs}/bin/clash"
          "-f"
          "/Users/aaron/.config/clash/config.yaml"
          "-d"
          "/Users/aaron/.local/state/clash"
        ];

        KeepAlive = true;
        RunAtLoad = true;

        StandardOutPath = "/Users/aaron/Library/Logs/clash.log";
        StandardErrorPath = "/Users/aaron/Library/Logs/clash.log";
      };
    };

    clipaste = {
      serviceConfig = {
        LimitLoadToSessionType = [
          "Aqua"
          "Background"
          "LoginWindow"
          "StandardIO"
          "System"
        ];

        SoftResourceLimits = {
          NumberOfFiles = 65536;
        };

        ProgramArguments = [
          "${pkgs.clipaste}/bin/clipaste"
        ];

        RunAtLoad = true;

        StandardOutPath = "/Users/aaron/Library/Logs/clipaste.log";
        StandardErrorPath = "/Users/aaron/Library/Logs/clipaste.log";
      };
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
    clipaste
    codex
    cue
    diffoscope
    duckdb
    dust
    duf
    fd
    ffmpeg
    file
    (callPackage ./pkg/funda { })
    gcx
    gh
    ghostscript
    glow
    go
    gojq
    golangci-lint
    gopls
    hunk
    imagemagick
    jd-diff-patch
    jujutsu
    just
    just-lsp
    k6
    (callPackage ./pkg/kafka-cli { })
    kubectl
    mcp-grafana
    mediainfo
    mysql-shell_8
    nmap
    nix-update
    nixd
    nixfmt
    oath-toolkit
    opencode
    pi-coding-agent
    (callPackage ./pkg/pi-zsh-completion { })
    pnpm_10
    postgresql
    ripgrep
    (callPackage ./pkg/redis-cli { })
    rtk
    ruff
    rust-analyzer
    skills
    socat
    swiftlint
    teleport
    temporal-cli
    ty
    uv
    viu
    xh
    zig
    zig-shell-completions
    zls
    (callPackage ./pkg/zoreman { })
    zon2nix
    zoxide
  ];
}
