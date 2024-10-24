{ pkgs, config, home-manager, ... }:
{
  programs.zsh = {
    enable = true;

    shellAliases = {
      ghprco = "gh pr checkout";
      ghprls = "gh pr list";
      ghprautos = "gh pr merge --auto -s";
      ghprautor = "gh pr merge --auto -r";
      ghprapprove = "gh pr review -a";
      ghdeprb = "gh pr comment -b \"@dependabot rebase\"";
      ghprv = "gh pr view";
      ghprvw = "ghprv -w";
      ghrepov = "gh repo view";
      ghrepovw = "ghrepov -w";

      vi = "vim";
      cat = "bat --plain";
      jq = "gojq";
      kd = "kitty +kitten diff";
    };

    history = {
      extended = true;
      ignoreAllDups = true;
    };

    initExtra = ''
      stty start undef # disable C-s stopping receiving keyboard signals.
      stty stop undef
      setopt MENU_COMPLETE # select first menu option automatically
      setopt NO_NOMATCH    # stop zsh from catching ^ chars.
      setopt AUTO_CONTINUE
      setopt APPEND_HISTORY
      setopt HIST_REDUCE_BLANKS

      mkcd() {
        mkdir -p "''$@"
        cd "''${@: -1}" || exit
      }

      gclcd() {
        gcl "$@" "$@" && cd "''${@: -1}" || exit
      }

      ghclcd() {
        gh repo clone "$@" "$@" && cd "''${@: -1}" || exit
      }

      kindc() {
        kind create cluster --name "''${1:-kind}" --image ghcr.io/mesosphere/kind-node:''${1:-$(crane ls ghcr.io/mesosphere/kind-node | grep -v 64 | sort -rV | head -1)} --config - <<EOF
      kind: Cluster
      apiVersion: kind.x-k8s.io/v1alpha4
      containerdConfigPatches:
      - |-
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://mirror.gcr.io"]
      - |-
        [plugins."io.containerd.grpc.v1.cri".registry.configs."registry-1.docker.io".auth]
          username = "jimmidyson"
          password = "$(gopass -n -o docker-credential-helpers/aHR0cHM6Ly9pbmRleC5kb2NrZXIuaW8vdjEv/jimmidyson)"
          auth = ""
          identitytoken = ""
      kubeadmConfigPatches:
      - |
        apiVersion: kubelet.config.k8s.io/v1beta1
        kind: KubeletConfiguration
        nodeStatusMaxImages: -1
      EOF
      }

      yubikeytouchoff() {
        ykman -d 20692469 openpgp keys set-touch sig off -f
        ykman -d 20692469 openpgp keys set-touch aut off -f
        ykman -d 20692469 openpgp keys set-touch enc off -f
      }

      yubikeytouchon() {
        ykman -d 20692469 openpgp keys set-touch sig cached -f
        ykman -d 20692469 openpgp keys set-touch aut cached -f
        ykman -d 20692469 openpgp keys set-touch enc cached -f
      }

      zstyle ':completion:*:make:*:targets' call-command true
      zstyle ':completion:*:*:make:*' tag-order 'targets'


      # export GITHUB_TOKEN="$(gopass -n -o github/hub)";
      export DO_NOT_TRACK="1";
      export MCFLY_RESULTS_SORT="LAST_RUN";

      export EDITOR=vim

      export PASSWORD_STORE_DIR="''${HOME}"/.local/share/gopass/stores/root
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aliases"
        "archlinux"
        "aws"
        "colored-man-pages"
        "colorize"
        "command-not-found"
        "direnv"
        "docker"
        "encode64"
        "extract"
        "flutter"
        "fluxcd"
        "fzf"
        "gcloud"
        "gh"
        "git"
        "git-extras"
        "gitignore"
        "golang"
        "gpg-agent"
        "helm"
        "history"
        "httpie"
        "istioctl"
        "keychain"
        "kubectl"
        "pre-commit"
        "rsync"
        "ruby"
        "systemd"
        "terraform"
        "universalarchive"
        "vi-mode"
        "vscode"
      ];
    };

    plugins = [
      {
        name = "zsh-history-substring-search";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "v1.1.0";
          hash = "sha256-GSEvgvgWi1rrsgikTzDXokHTROoyPRlU0FVpAoEmXG4=";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          hash = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          hash = "sha256-DWVFBoICroKaKgByLmDEo4O+xo6eA8YO792g8t8R7kA=";
        };
      }
    ];
  };
}
