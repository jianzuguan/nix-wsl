{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    # FIXME: select your core binaries that you always want on the bleeding-edge
    # bat
    bottom
    coreutils
    curl
    # du-dust
    # fd
    # findutils
    # fx
    git
    git-crypt
    htop
    jq
    # killall
    # mosh
    # procs
    # ripgrep
    # sd
    # tmux
    tree
    unzip
    vim
    wget
    zip
  ];

  stable-packages = with pkgs; [
    # FIXME: customize these stable packages to your liking for the languages that you use

    # key tools
    gh # for bootstrapping
    # just

    # core languages
    # rustup

    # rust stuff
    # cargo-cache
    # cargo-expand

    # local dev stuf
    # mkcert
    # httpie

    # treesitter
    # tree-sitter
    jdk
    go

    # language servers
    nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    nil # nix

    # formatters and linters
    alejandra # nix
    deadnix # nix
    nodePackages.prettier
    shellcheck
    # shfmt
    statix # nix
    zoxide
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
    ./fish.nix
    ./git.nix
    ./starship.nix
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    # FIXME: set your preferred $SHELL
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    # FIXME: you can add anything else that doesn't fit into the above two lists in here
    [
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableFishIntegration = true;
    nix-index-database.comma.enable = true;

    # FIXME: disable whatever you don't want
    fzf.enable = true;
    fzf.enableFishIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    lsd.settings = {
      #https://github.com/lsd-rs/lsd#config-file-content
      date = "+%Y-%m-%d %H:%M:%S";
      icons = {
        when = "never";
      };
      sorting.dir-grouping = "first";
    };
    zoxide.enable = true;
    zoxide.enableFishIntegration = true;
    broot.enable = true;
    broot.enableFishIntegration = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    

    
  };
}
