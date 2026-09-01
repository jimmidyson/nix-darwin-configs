# Overlays shared by every host. Imported by roles/defaults.nix for the
# nix-darwin hosts, and applied directly when instantiating nixpkgs for the
# standalone home-manager (Linux) hosts, which never evaluate the nix-darwin
# modules.
[
  (_final: prev: {
    fzf-git-sh = prev.fzf-git-sh.overrideAttrs (oldAttrs: {
      postPatch = (oldAttrs.postPatch or "") + ''
        substituteInPlace fzf-git.sh \
          --replace-fail '${prev.fzf}/bin/fzf-git-' 'fzf-git-'
      '';

      installCheckPhase = (oldAttrs.installCheckPhase or "") + ''
        ${prev.gnugrep}/bin/grep -Fq '${prev.fzf}/bin/fzf --height' \
          "$out/share/fzf-git-sh/fzf-git.sh"
        if ${prev.gnugrep}/bin/grep -Fq '${prev.fzf}/bin/fzf-git-' \
          "$out/share/fzf-git-sh/fzf-git.sh"; then
          echo "fzf-git widget identifiers contain the fzf store path" >&2
          exit 1
        fi
        ${prev.zsh}/bin/zsh -dfi -c '
          source "$out/share/fzf-git-sh/fzf-git.sh"
          typeset -f fzf-git-files-widget >/dev/null
        '
      '';
    });
  })
]
