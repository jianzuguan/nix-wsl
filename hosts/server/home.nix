{
# FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
# secrets,
pkgs, username, nix-index-database, ... }:
let
  stable-packages = with pkgs; [
    bottom
    corepack
    coreutils
    curl
    fnm
    fzf
    gh
    git
    jdk
    jq
    lsd
    tree
    unzip
    vim
    wget
    zip
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

  home = {
    stateVersion = "22.11";

    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";

    packages = stable-packages;
  };
  programs = {
    home-manager.enable = true;

    nix-index.enable = true;
    nix-index.enableFishIntegration = true;
    nix-index-database.comma.enable = true;

    fzf.enable = true;
    fzf.enableFishIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    lsd.settings = {
      #https://github.com/lsd-rs/lsd#config-file-content
      date = "+%Y-%m-%d %H:%M:%S";
      icons = { when = "never"; };
      sorting.dir-grouping = "first";
    };
    zoxide.enable = true;
    zoxide.enableFishIntegration = true;
  };
}
