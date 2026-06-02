{ lib
, stdenvNoCC
, fetchurl
}:

let
  version = "0.2.0";

  # goreleaser publishes one archive per platform. Building from source with
  # buildGoModule is the nicer option, but pulling the (large) module zips
  # through proxy.golang.org is unreliable on this network, so consume the
  # official prebuilt binaries instead. They are CGO-free static Go builds
  # with version metadata already injected at release time.
  platforms = {
    aarch64-darwin = {
      suffix = "darwin_arm64";
      hash = "sha256-6+s5jZ+zpfHmve4L0VdiAxCKMIDoBae1NbRoxF/QdcE=";
    };
    x86_64-darwin = {
      suffix = "darwin_amd64";
      hash = "sha256-1wFAkce9aATuyl9tZGchwfGrzumUFJbuyraM2lF67Tg=";
    };
    aarch64-linux = {
      suffix = "linux_arm64";
      hash = "sha256-Kq+0dAh6cZqr6GC7SuOzwUUvhmVJcf2Y5MYSKnTQpQ4=";
    };
    x86_64-linux = {
      suffix = "linux_amd64";
      hash = "sha256-NamzoiphvwCaj/+xc5lV3iI20lw9WV0gXE6f5EpzMlE=";
    };
  };

  platform =
    platforms.${stdenvNoCC.hostPlatform.system}
      or (throw "troubleshoot-live: unsupported platform ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "troubleshoot-live";
  inherit version;

  src = fetchurl {
    url = "https://github.com/mhrabovcin/troubleshoot-live/releases/download/v${finalAttrs.version}/troubleshoot-live_v${finalAttrs.version}_${platform.suffix}.tar.gz";
    inherit (platform) hash;
  };

  # Archive holds the binary plus docs at the top level, no wrapping directory.
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 troubleshoot-live $out/bin/troubleshoot-live
    runHook postInstall
  '';

  meta = {
    description = "Explore Troubleshoot support bundles through a live, local Kubernetes-style API server";
    homepage = "https://github.com/mhrabovcin/troubleshoot-live";
    license = lib.licenses.asl20;
    mainProgram = "troubleshoot-live";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames platforms;
  };
})
