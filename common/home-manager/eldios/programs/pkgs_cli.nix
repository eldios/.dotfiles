{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # Golang
      go

      # NodeJS
      bun
      nodejs
      nodenv

      # Rust
      cargo
      pkg-config
      protobuf
      rustc
      rustfmt

      # Haskell
      ghc

      # Python3
      python3

      # DevOps stuff
      act # run GitHub Actions Locally
      age
      atac
      awscli2
      azure-cli
      bc
      cdrkit
      ddrescue
      dnsutils
      docker
      doctl # Digital Ocean CLI tool
      gitleaks
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      infisical
      jira-cli-go
      jless
      linode-cli
      metal-cli # official Equinix Metal CLI
      opentofu
      portal
      postman
      sops
      sshs
      terracognita
      terraform
      terraform-compliance
      terraform-landscape
      terraform-ls
      terraformer
      terraforming
      terragrunt
      terraspace
      tflint
      tflint-plugins.tflint-ruleset-aws
      tfswitch
      tmate
      vultr-cli

      # Kubernetes stuff
      argocd
      devpod
      devspace
      eksctl
      helmfile
      k8sgpt
      k9s
      k0sctl
      kdash
      kind
      ktop
      kubectx
      kubelogin
      kubelogin-oidc
      kubernetes-helm
      skaffold
      teleport
      tfk8s
      vcluster
      yamlfmt
      yamllint

      # nix stuff
      cachix # adding/managing alternative binary caches hosted by Cachix
      comma # run software from without installing it
      niv # easy dependency management for nix projects
      nix-prefetch-git
      nix-prefetch-github
      nixfmt-rfc-style # in future this will be -> nixfmt
      nodePackages.node2nix
      prefetch-npm-deps

      # charm.sh CLI utils
      glow
      gum
      mods
      vhs
      zfxtop

      # utils
      asciiquarium
      bombadillo
      btop
      calcurse
      cbonsai
      cmatrix
      cowsay
      entr
      exfat
      fd # A simple, fast and user-friendly alternative to find
      figlet
      fortune
      gcc
      github-cli
      glances
      gnupg
      inetutils
      inxi
      just
      lolcat
      lzip
      mtr
      nix-tree
      nnn
      nyancat
      parallel
      pciutils
      pls
      psmisc
      pv
      pwgen
      rclone
      ripgrep
      ripgrep-all
      sipcalc
      sl
      socat
      sshfs
      tldr
      tmux
      toilet
      unzip
      usbutils
      util-linux
      wget
      yazi
      zip
    ];
  };
} # EOF
# vim: set ts=2 sw=2 et ai list nu
