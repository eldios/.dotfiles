{ pkgs, nixpkgs-unstable, ... }:
let
  unstablePkgs = import nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  myFastFetchOpt = "-s 'Title:Separator:OS:Host:Uptime:Separator:Packages:Kernel:Shell:WM:Terminal:TerminalFont:Separator:CPU:GPU:Memory:Swap:Disk:LocalIp'";

  nvim = unstablePkgs.neovim;

  binDir = "/etc/profiles/per-user/eldios/bin";
in
{

  home = {
    packages = with pkgs; [
      carapace
      #colorls # like `ls --color=auto -F` but cooler
      fastfetch
      fzf
      lsd
      nnn
      thefuck
      zoxide
    ];
  }; # EOM ZSH deps

  programs = {

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
      };

      syntaxHighlighting = {
        enable = true;
      };

      localVariables = {
        TERM = "xterm-256color";
        EDITOR = "${binDir}/nvim";
        VISUAL = "${binDir}/nvim";

        ZELLIJ_AUTO_ATTACH = false;
        ZELLIJ_AUTO_EXIT = false;

        SOPS_AGE_KEY_FILE = "/etc/sops/key.txt";
      };

      history = {
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        expireDuplicatesFirst = true;
        ignorePatterns = [
          "pkill"
        ];
        share = true;
      };

      shellAliases = {
        ls = "lsd";
        ll = "ls -lh";
        l = "ls -lhtra";

        g = "git";
        lg = "lazygit";

        n = "nnn";
        y = "yazi";

        # Kubectl
        k = "kubectl";
        j = "just";

        ji = "jira issue";
        jil = "jira issue list";
        jim = "jira issue list -a lele@switchboard.xyz --order-by STATUS";

        TF = "terraform";
        tf = "tofu";
        tfp = "tf plan";
        tfa = "tf apply -auto-approve";
        tfd = "tf destroy -auto-approve";

        cg = "cargo";
        cgb = "cg build";
        cgc = "cg check";
        cgn = "cg new";
        cgr = "cg run";
        cgt = "cg test";

        ipcalc = "sipcalc";
        ff = "${binDir}/fastfetch ${myFastFetchOpt}";

        nixs = "nix search nixpkgs";
        nixe = "$EDITOR $HOME/dotfiles/hosts/$(hostname)";

        nixu = "sudo nixos-rebuild switch --impure --flake $HOME/dotfiles";
        nixU = "sudo nix flake update $HOME/dotfiles && nixu";

        nixa = "nixe && nixu";
        nixA = "nixe && nixU";

        hm = "home-manager";
        hmc = "hm-cleanup";
        hme = "hm-edit";
        hmu = "hm-update";
        hmU = "nixu && hm-update";
        hma = "hme && hmu";
        hmA = "hme && hmU";
        hm-cleanup = "home-manager expire-generations '-7 days' && nix-store --gc";
        hm-edit = "home-manager edit";
        hm-update = "home-manager switch -b backup --flake $HOME/dotfiles'";

        SHX = "exec \$SHELL -l";
      };

      shellGlobalAliases = {
        UUID = "$(uuidgen | tr -d \\n)";
        G = "| grep";
      };

      dirHashes = {
        df = "$HOME/dotfiles";
        dl = "$HOME/Downloads";
      };

      initExtra = ''
        bindkey '^P' history-beginning-search-backward
        bindkey '^N' history-beginning-search-forward

        zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
        source <(${binDir}/carapace _carapace zsh)

        eval "$(${binDir}/thefuck --alias)"
        eval "$(${binDir}/zoxide init zsh)"

        ${binDir}/fastfetch ${myFastFetchOpt}
      '';
    }; # EOM zsh

  }; # EOM programs

} # EOF
# vim: set ts=2 sw=2 et ai list nu
