{ pkgs, ... }: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        IdentityFile ~/.ssh/jz-github
    '';
  };
}
