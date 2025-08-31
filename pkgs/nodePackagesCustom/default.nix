{pkgs, ...}: {
  # Note: You wouldn't be able to something like stylelint-config-clean-order = pkgs.callPackage (import ./devTools/stylelint.nix {inherit pkgs;}).stylelint-config-clean-order because you would be feeding callPackage an already evaluated attrset and built derivation
  stylelint-config-clean-order = pkgs.buildNpmPackage rec {
    pname = "stylelint-config-clean-order";
    version = "v7.0.0"; # match the npm release you want

    src = pkgs.fetchFromGitHub {
      owner = "kutsan";
      repo = "stylelint-config-clean-order";
      tag = version;
      sha256 = "049jyf58xcnnp5aa48zljplx1rw606l5fwf5cv6skzzinkhrchj8"; # nix-prefetch-url --unpack https://github.com/kutsan/stylelint-config-clean-order/archive/v7.0.0.tar.gz
    };
    # use the package.json shipped in the repo
    packageJSON = src + "/package.json";
    npmDepsHash = "sha256-Z+n6kd24gcQXmNWhOy4vBLO/e+2dLOfdZtb/1pgkMRw=";

    dontNpmBuild = true;
  };
  stylelint-high-performance-animation = pkgs.mkYarnPackage rec {
    pname = "stylelint-high-performance-animation";
    version = "v1.11.0"; # match the npm release you want

    src = pkgs.fetchFromGitHub {
      owner = "kristerkari";
      repo = "stylelint-high-performance-animation";
      tag = version;
      sha256 = "16pd32x4zjgh2aprrsawpq4c597yzlqnli5czgq5nhh15h0v53fw"; # nix-prefetch-url --unpack https://github.com/kutsan/stylelint-config-clean-order/archive/v7.0.0.tar.gz
    };
    localCache = pkgs.fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      # run `nix build .#offlineCache --no-link` or `nix-prefetch-yarn-deps`
      hash = "sha256-k6D6snbYsEAJknUvFMbUACpnHewIf5Cx+Na+ST/6qOk=";
    };
    # use the yarn.lock shipped in the repo
    yarnLock = src + "/yarn.lock";
    offlineCache = localCache;
  };
}
