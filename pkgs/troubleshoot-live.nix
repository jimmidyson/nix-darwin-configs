{ lib
, buildGo126Module
, fetchFromGitHub
}:

let
  version = "0.2.0";
  # v0.2.0 commit; pinned so the injected version metadata is reproducible.
  rev = "bf18ebdb4224d4aeb9dd423d17e267f8fdc153ba";
  commitDate = "2026-04-30T15:04:35Z";
  # goreleaser stamps version info into dkp-cli-runtime's version package; a plain
  # source build would otherwise report an empty/dev version (the upstream flake
  # hardcodes 0.0.0). See .goreleaser.yaml.
  versionPkg = "github.com/mesosphere/dkp-cli-runtime/core/cmd/version";
in
# go.mod requires Go 1.26; the default `go` in our pinned nixpkgs is still 1.25.
buildGo126Module {
  pname = "troubleshoot-live";
  inherit version;

  src = fetchFromGitHub {
    owner = "mhrabovcin";
    repo = "troubleshoot-live";
    rev = "v${version}";
    hash = "sha256-sQmExJyzCFirWAfTUu82bq2VAjo7hHcDDazjogZ0j98=";
  };

  # Tied to the v0.2.0 go.sum, not to the Go/nixpkgs version; taken from the
  # upstream flake tagged at v0.2.0 and re-verified by the build.
  vendorHash = "sha256-U1ATmY1hXkQ62BC3G9ug7rNr4YIinF/fdrnFovJpg04=";

  # `.` is the only real entrypoint; skip compiling internal packages.
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X ${versionPkg}.gitVersion=v${version}"
    "-X ${versionPkg}.gitCommit=${rev}"
    "-X ${versionPkg}.gitTreeState=clean"
    "-X ${versionPkg}.commitDate=${commitDate}"
    "-X ${versionPkg}.major=0"
    "-X ${versionPkg}.minor=2"
  ];

  # Upstream tests stand up controller-runtime envtest (etcd/kube-apiserver
  # binaries + network), which can't run in the Nix sandbox.
  doCheck = false;

  meta = {
    description = "Explore Troubleshoot support bundles through a live, local Kubernetes-style API server";
    homepage = "https://github.com/mhrabovcin/troubleshoot-live";
    license = lib.licenses.asl20;
    mainProgram = "troubleshoot-live";
    platforms = lib.platforms.unix;
  };
}
