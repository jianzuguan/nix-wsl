{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      ${pkgs.lib.strings.fileContents (pkgs.fetchFromGitHub {
          owner = "rebelot";
          repo = "kanagawa.nvim";
          rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
          sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
        }
        + "/extras/kanagawa.fish")}

      set -U fish_greeting

      # Read tokens from ~/.tokens and export them as environment variables
      if test -f "$HOME/.config/tokens/tokens"
        for line in (cat $HOME/.config/tokens/tokens | grep -v '^#' | grep '=')
          set arr (echo $line | tr '=' '\n')
          set -gx $arr[1] $arr[2]
        end
      end

      fnm env --use-on-cd --shell fish | source
    '';
    functions = {
      refresh = "source $HOME/.config/fish/config.fish";
      take = ''mkdir -p -- "$1" && cd -- "$1"'';
      ttake = "cd $(mktemp -d)";
      show_path = "echo $PATH | tr ' ' '\n'";
      posix-source = ''
        for i in (cat $argv)
          set arr (echo $i |tr = \n)
          set -gx $arr[1] $arr[2]
        end
      '';
    };
    shellAbbrs =
      {
        gc = "nix-collect-garbage --delete-old";
      }
      # navigation shortcuts
      // {
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
      }
      // {
        dc = "docker compose";
        dcu = "docker compose up -d";
        dcd = "docker compose down";
        dcl = "docker compose logs";
      };
    shellAliases = {
      pbcopy = "/mnt/c/Windows/System32/clip.exe";
      pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
      explorer = "/mnt/c/Windows/explorer.exe";
      lsdf = "lsd -al";

      # To use code as the command, uncomment the line below. Be sure to replace [my-user] with your username. 
      # If your code binary is located elsewhere, adjust the path as needed.
      code = "/mnt/c/Users/j/AppData/Local/Programs/'Microsoft VS Code'/bin/code";
    };
    plugins = [
      {
        inherit (pkgs.fishPlugins.autopair) src;
        name = "autopair";
      }
      {
        inherit (pkgs.fishPlugins.done) src;
        name = "done";
      }
      {
        inherit (pkgs.fishPlugins.sponge) src;
        name = "sponge";
      }
    ];
  };
}