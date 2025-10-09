{ pkgs, lib, ... }:
let
  backport = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "backport";
    version = "10.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "sorenlouv";
      repo = "backport";
      rev = "v${finalAttrs.version}";
      hash = "sha256-QjFujXthhLMlFQbuwMKc9cyqFVSkvc9M9GIC7vOCeyA=";
    };

    offlineCache = pkgs.fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/yarn.lock";
      hash = "sha256-lXummlj8uce9H9UaLgjl1ULF9XU/1EclwEjJq+9YsaQ=";
    };

    nativeBuildInputs = [
      pkgs.yarnConfigHook
      pkgs.yarnBuildHook
      pkgs.yarnInstallHook
      # Needed for executing package.json scripts
      pkgs.nodejs
    ];
  });
in
{
  home.packages = [ backport ];
}
