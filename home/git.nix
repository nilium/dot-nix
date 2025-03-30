{
  pkgs,
  lib,
  config,
  ...
}: {
  options.dotnix.git = {
    signingKey = lib.mkOption {
      type = lib.types.str;
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "ncower@nil.dev";
    };
  };

  config = {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Noel";
          inherit (config.dotnix.git) email;
        };
        signing =
          {
            backend = "ssh";
            key = config.dotnix.git.signingKey;
            backends.ssh.allowed-signers = "~/.ssh/authorized_signers";
          }
          // (
            if pkgs.lib.versionAtLeast pkgs.jujutsu.version "0.27"
            then {behavior = "own";}
            else {sign-all = true;}
          );

        git.auto-local-bookmark = true;
        ui.default-command = "log";
      };
    };

    programs.git = {
      enable = true;
      userEmail = config.dotnix.git.email;
      userName = "Noel";
      difftastic.enable = true;

      ignores = [
        # Swap.
        "*~"
        ".sw[a-z]"
        ".*.sw[a-z]"
        # MacOS.
        ".DS_Store"
        # Archives.
        "*.zip"
        "*.tar.*"
        "*.tgz"
        "*.txz"
        "*.tzst"
        "*.a"
        # Packages.
        "*.deb"
        "*.rpm"
        "*.xbps"
        "*.pkg"
        # Misc Windows.
        "*.exe"
        "*.dll"
        # Disk images.
        "*.qcow"
        "*.qcow2"
        "*.qcow3"
        "*.dmg"
        # Temp files.
        "*.tmp"
        "*.tmp[.-]*"
        "*.temp"
        "*.temp[.-]*"
        "*.scratch"
        "*.scratch[.-]*"
        "*.bak"
        "*.bak[.-]*"
        "*.old"
        "*.old[.-]*"
        "_temp/"
        "_scratch/"
        "_misc/"
        "_bak/"
        # jj
        ".jj"
        # Undo
        "[._]*.un~"
        # Vim
        "Session.vim"
        "Sessionx.vim"
        # node
        "node_modules/"
        # direnv
        ".direnv/"
        # Nix
        "result/"
        # sql
        ".sqlrc"
      ];

      extraConfig = {
        core = {
          quotepath = false;
          pager = "less -F -X";
        };

        diff.algorithm = "histogram";

        merge.summary = true;

        rebase = {
          autoSquash = true;
          autoStash = false;
        };

        push = {
          default = "simple";
          rebase = "preserve";
        };

        pull.ff = "only";

        init.defaultBranch = "main";

        status.submoduleSummary = false;

        commit = {
          verbose = true;
          gpgSign = true;
        };

        # SSH signing config.
        user.signingkey = [config.dotnix.git.signingKey];
        gpg = {
          format = ["ssh"];
          ssh.allowedSignersFile = ["~/.ssh/authorized_signers"];
        };
      };

      aliases = {
        fixme = ''!git grep -F -e "FIXME($(git config --global user.email | fex @1)):" -e "FIXME:"'';
        # Commit graphs
        # Borrowed/modified from user "Slipp D. Thompson"'s answer at http://stackoverflow.com/a/9074343/457812
        alog = "log --all --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s - %an%C(reset)%C(bold yellow)%d%C(reset)'";
        glog = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s - %an%C(reset)%C(bold yellow)%d%C(reset)'";
        glogd = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %s%C(reset) - %an%C(reset)'";
        fup = "push --force-with-lease";
        slog = "log --format=oneline";
        # Less general-purpose aliases
        ap = "add --patch";
        br = "branch";
        ci = "commit";
        co = "checkout";
        cv = "commit --verbose --untracked-files=no";
        cav = "cv --amend";
        dc = "diff --cached";
        df = "difftool";
        logwhen = "log --pretty='%h: %an (%aD)'";
        lol = "log --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s - %an%C(reset)%C(bold yellow)%d%C(reset)'";
        lp = "log --pretty=short --name-status";
        lps = "log --pretty=medium --name-status";
        lsd = "stash list --name-status --abbrev-commit --decorate --format=format:'%C(bold yellow)%<|(11)%gd %C(bold blue)%h%C(reset)  %C(bold green)%>(16)%ar ⇒ %C(reset) %s%C(reset)'";
        pff = "pull --ff-only";
        rh = "reset HEAD";
        ri = "rebase --interactive";
        s = "status -uno";
        sm = "submodule";
        st = "status";
        who = "shortlog -s --";
      };
    };
  };
}
