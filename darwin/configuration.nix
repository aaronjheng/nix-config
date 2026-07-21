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

  documentation.enable = false;
  system.tools.darwin-uninstaller.enable = false;

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
          "/etc/profiles/per-user/aaron/bin/chezmoi"
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
          "/etc/profiles/per-user/aaron/bin/clash"
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
          "/etc/profiles/per-user/aaron/bin/clipaste"
        ];

        RunAtLoad = true;

        StandardOutPath = "/Users/aaron/Library/Logs/clipaste.log";
        StandardErrorPath = "/Users/aaron/Library/Logs/clipaste.log";
      };
    };

    ollama = {
      serviceConfig = {
        ProgramArguments = [
          "/etc/profiles/per-user/aaron/bin/ollama"
          "serve"
        ];

        EnvironmentVariables = {
          OLLAMA_FLASH_ATTENTION = "1";
          OLLAMA_KEEP_ALIVE = "30m";
          OLLAMA_KV_CACHE_TYPE = "q8_0";
        };

        RunAtLoad = true;

        StandardOutPath = "/Users/aaron/Library/Logs/ollama.log";
        StandardErrorPath = "/Users/aaron/Library/Logs/ollama.log";
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
    (
      let
        codexVersion = "0.144.5";
      in
      codex.overrideAttrs (old: {
        version = codexVersion;
        src = fetchFromGitHub {
          owner = "openai";
          repo = "codex";
          rev = "rust-v${codexVersion}";
          hash = "sha256-v8MsNWeqiYsTvPtlXs8UMuZKLf7Cj71Vl+MHXihAkos=";
        };
        cargoHash = "sha256-u2wqR1kQawFuvm5nOHbYjlghZL1n3GnnmvNfDLBYvY8=";
      })
    )
    # container
    (
      let
        crushVersion = "0.86.0";
        go_1_26_5 = pkgs.go_1_26.overrideAttrs (old: {
          version = "1.26.5";
          src = pkgs.fetchurl {
            url = "https://go.dev/dl/go1.26.5.src.tar.gz";
            hash = "sha256-SVvkvIcXasVnOS5bQRar2YRm0z17SdQedkzMaXay3EI=";
          };
        });
      in
      (crush.override {
        buildGo126Module = pkgs.buildGo126Module.override { go = go_1_26_5; };
      }).overrideAttrs
        (old: {
          version = crushVersion;
          src = fetchFromGitHub {
            owner = "charmbracelet";
            repo = "crush";
            tag = "v${crushVersion}";
            hash = "sha256-dUeXU65A9/d365a9Z+eUoHOR0RnJV9SAYsks+Vtz9js=";
          };
          vendorHash = "sha256-9WkkosPMwXsj32a5Zj4ZxphuB7aVteKq/YTzxP9Xmf0=";
          patches = [
            ./patches/crush-sidebar-version.patch
            ./patches/crush-hide-logo.patch
            ./patches/crush-hide-help.patch
            ./patches/crush-configured-providers-first.patch
          ];

          doCheck = false;
        })
    )
    cue
    (cursor-cli.overrideAttrs (old: {
      version = "2026.07.16-899851b";
      src = fetchurl {
        url = "https://downloads.cursor.com/lab/2026.07.16-899851b/darwin/arm64/agent-cli-package.tar.gz";
        hash = "sha256-wM17Y8AftjtE4zx6JhNDLo/YyxOIHacqwWE8nxQIEV8=";
      };
    }))
    # diffoscope
    duckdb
    dust
    duf
    fd
    ffmpeg
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
    jujutsu
    just
    just-lsp
    k6
    (callPackage ./pkg/kafka-cli { })
    kubectl
    mediainfo
    mitmproxy
    mysql-shell_8
    nmap
    nix-update
    nixd
    nixfmt
    oath-toolkit
    (callPackage ./pkg/ollama-bin { })
    (callPackage ./pkg/opencode { })
    (
      let
        piVersion = "0.80.10";
      in
      pi-coding-agent.overrideAttrs (old: {
        version = piVersion;
        src = fetchurl {
          url = "https://github.com/earendil-works/pi/archive/refs/tags/v${piVersion}.tar.gz";
          hash = "sha256-E0dp/aaQSoHhH9xnuRIJx6S0kDxmrZOrn/jIvce1uLw=";
        };
      })
    )
    pnpm_10
    postgresql
    python3
    python3Packages.ipython
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
    typescript-language-server
    uv
    viu
    xh
    zig
    zls
    zig-shell-completions
    (callPackage ./pkg/zoreman { })
    zon2nix
    zoxide
  ];
}
