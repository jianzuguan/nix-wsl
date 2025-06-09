{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [    # bat
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
    tree
    unzip
    vim
    wget
    zip
  ];

  stable-packages = with pkgs; [
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

    fnm
    corepack
    jdk
    go

    # formatters and linters
    alejandra # nix formatter
    statix # Lints and suggestions for the Nix programming language

    zoxide
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
    ../../modules/fish.nix
    ../../modules/git.nix
    ../../modules/ssh.nix
    ../../modules/starship.nix
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    # FIXME: set your preferred $SHELL
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";
  };

  home.packages = stable-packages ++ unstable-packages;

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
