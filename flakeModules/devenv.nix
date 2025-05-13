{
  pkgs,
  inputs',
  config,
  ...
}: let
  commonPackages = with pkgs; [
    inputs'.nixd.packages.nixd
    inputs'.alejandra.packages.default
    inputs'.statix.packages.default
    ltex-ls-plus
    marksman
    codespell
    gitleaks
    commitlint
    bash-language-server
  ];
in {
  devenv.shells.default = {
    cachix = {
      enable = true;
      pull = ["pre-commit-hooks"];
    };
    git-hooks = {
      enabledPackages = with pkgs; [
        deadnix
        clang-tools
        cmake-format
        cargo
        # clippy
        config.treefmt.build.wrapper
        convco
        mdsh
        gitleaks
      ];
      hooks = {
        deadnix.enable = true;
        markdownlint.enable = true;
        mdsh.enable = true;
        flake-checker.enable = true;
        check-merge-conflicts.enable = true;
        commitizen.enable = true;
        # trufflehog.enable = true;
        convco.enable = true;
        forbid-new-submodules.enable = true;
        gitleaks = {
          name = "gitleaks";
          enable = true;
          entry = "gitleaks dir";
        };
        # clang-tidy.enable = true;
        # cargo-check.enable = true;
        # clippy.enable = true;
        # rustfmt.enable = true;
        treefmt = {
          enable = true;
          package = config.treefmt.build.wrapper;
        };
        statix = {
          enable = true;
          package = inputs'.statix.packages.default;
        };
      };
    };
    languages.rust = {
      enable = true;
      channel = "nightly";
    };
    packages = with pkgs;
      [
        inputs'.rustacean.packages.codelldb
        graphviz
        rust-analyzer
      ]
      ++ commonPackages;
  };
}
