{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.unstable.git;
    delta.enable = true;
    delta.options = {
      line-numbers = true;
      side-by-side = true;
      navigate = true;
    };
    userEmail = "git@jzg.fastmail.com";
    userName = "Zo";
    extraConfig = {
      # FIXME: uncomment the next lines if you want to be able to clone private https repos
      # url = {
      #   "https://oauth2:${secrets.github_token}@github.com" = {
      #     insteadOf = "https://github.com";
      #   };
      #   "https://oauth2:${secrets.gitlab_token}@gitlab.com" = {
      #     insteadOf = "https://gitlab.com";
      #   };
      # };
      init = { defaultBranch = "main"; };
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      pull = { rebase = true; };
      merge = { conflictstyle = "diff3"; };
      diff = { colorMoved = "default"; };
      alias = {
        a = "add";
        aa = "add .";
        b = "branch --sort=-committerdate";
        bn = "checkout -b";
        c = "checkout";
        coi =
          "!git checkout $(git branch --sort=-committerdate | grep -v HEAD | sed 's/^[* ] //' | fzf)";
        s = "status";
        sts = "stash";
        stsp = "stash pop";
        l = "log --oneline -n 10";
      };
    };
  };
}
