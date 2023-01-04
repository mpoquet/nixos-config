{ config, pkgs, localPkgs }:

let
  aliases = {
    cal = "cal --monday --week";
    disable-screen-saver = "xset -dpms";
    g = "git";
    j = "jump";
    l = "llpp";
    lu = "killall -HUP --regexp '(.*bin/)?llpp'";
    nb = "nix-build";
    ne = "nix-env";
    nightshift = "systemctl stop --user redshift ; redshift -O 4500";
    ns = "nix-shell --command zsh";
    op = "xdg-open";
    bat = "bat --theme=ansi";
    pat = "bat -p";
    ssh = "TERM=xterm-color ssh";
    cdr = "cd $(git rev-parse --show-toplevel || echo .)";
  };
in {
  programs.bash = {
    shellAliases = aliases;
  };

  programs.zsh = {
    enable = true;
    shellAliases = aliases;
    enableCompletion = true;
    autosuggestions.enable = false;
    ohMyZsh = {
      enable = true;
      plugins = [ "jump" "colored-man-pages" ];
      package = localPkgs.oh-my-zsh-mpoquet;
      theme = "mpoquet";
    };
    interactiveShellInit = ''
      export EDITOR=vim
      tabs 4

      function rw () {
        which_result=$(which $1 2>&1)
        which_exit_code=$?
        if [ ''${which_exit_code} -eq 0 ]; then
          echo $(realpath "''${which_result}")
        else
          echo "''${which_result}"
        fi
        return ''${which_exit_code}
      }

      function div-branches-roots() {
        echo "$1 $2 $(git merge-base $1 $2)^\!"
      }

      #NIX_BUILD_SHELL=zsh
    '';
    promptInit = "";
  };
}
