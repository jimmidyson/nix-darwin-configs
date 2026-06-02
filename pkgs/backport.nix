{ lib
, buildNpmPackage
, fetchurl
, jq
, nodejs_22
}:

let
  version = "11.0.2";

  # npm strips package-lock.json from published tarballs (regardless of the
  # "files" field), but buildNpmPackage requires one. Vendor it from the
  # matching git tag; it corresponds to the prebuilt dist/ in the tarball.
  packageLock = fetchurl {
    url = "https://raw.githubusercontent.com/sorenlouv/backport/v${version}/package-lock.json";
    hash = "sha256-wJGx966ovyp6Adtf6ybvN4Im4EitIQC28usnQdviIiw=";
  };
in
buildNpmPackage {
  pname = "backport";
  inherit version;

  # Use the published npm tarball rather than the git tag: it ships a prebuilt
  # dist/, so we avoid the source build (husky git hooks and graphql-codegen,
  # neither of which work in the sandbox).
  src = fetchurl {
    url = "https://registry.npmjs.org/backport/-/backport-${version}.tgz";
    hash = "sha256-qjuZpprllJxgcVJmbbv9I7rLCF0u1QpIOC1gESdu8NM=";
  };

  postPatch = ''
    cp ${packageLock} package-lock.json
    # dist/ is prebuilt in the tarball, so drop the lifecycle scripts that would
    # otherwise run husky / graphql-codegen (absent here). npm pack, run by the
    # install hook, triggers `prepare` regardless of --ignore-scripts.
    ${jq}/bin/jq 'del(.scripts.prepare, .scripts.postinstall, .scripts.prepublishOnly)' \
      package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-VAKEOZ+z5QkCxh30/tsQDzp+DWzysypKpLdl2+3vIkI=";

  # backport requires Node >= 22 (see package.json "engines").
  nodejs = nodejs_22;

  # dist/ is already built in the tarball; only runtime deps are needed.
  dontNpmBuild = true;

  # Skip lifecycle scripts for *every* npm invocation: `prepare` runs
  # `husky && npm run build` (husky is absent and dist/ is prebuilt), and the
  # install hook's `npm pack` would otherwise trigger it too.
  npmFlags = [ "--ignore-scripts" ];

  # Only runtime deps are needed to run the CLI.
  npmInstallFlags = [ "--omit=dev" ];

  meta = {
    description = "CLI tool that automates the process of backporting commits";
    homepage = "https://github.com/sorenlouv/backport";
    license = lib.licenses.asl20;
    mainProgram = "backport";
  };
}
