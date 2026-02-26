{
  inputs,
  mkShell,
  system,
  ...
}: let
  pkgs = import inputs.nixpkgs {
    inherit system;
  };
  pkgs-ansible = import inputs.nixpkgs2505 {
    inherit system;
  };
in
mkShell {
  packages = with pkgs; [
    (pkgs-ansible.runCommand "ansible_2_16" {buildInputs = [pkgs-ansible.ansible_2_16 pkgs.makeWrapper];} ''
      mkdir -p $out/bin
      makeWrapper ${pkgs-ansible.ansible_2_16}/bin/ansible $out/bin/ansible_2_16 --set PYTHONPATH "${pkgs-ansible.ansible_2_16}/lib"
      makeWrapper ${pkgs-ansible.ansible_2_16}/bin/ansible-playbook $out/bin/ansible-playbook_2_16 --set PYTHONPATH "${pkgs-ansible.ansible_2_16}/lib"
    '')
    (pkgs-ansible.runCommand "ansible_2_17" {buildInputs = [pkgs-ansible.ansible_2_17 pkgs.makeWrapper];} ''
      mkdir -p $out/bin
      makeWrapper ${pkgs-ansible.ansible_2_17}/bin/ansible $out/bin/ansible_2_17 --set PYTHONPATH "${pkgs-ansible.ansible_2_17}/lib"
      makeWrapper ${pkgs-ansible.ansible_2_17}/bin/ansible-playbook $out/bin/ansible-playbook_2_17 --set PYTHONPATH "${pkgs-ansible.ansible_2_17}/lib"
    '')
    pkgs.ansible
    pkgs.ansible-lint
    pkgs.just
    pkgs.fzf-make
    pkgs.rbw
    pkgs.pinentry-curses
    pkgs.openssh_gssapi
    pkgs.tflint
    pkgs.tfsec
    pkgs.terraform
    pkgs.gum
    pkgs.ansible-recap
    pkgs.pre-commit
    pkgs.shellcheck
    pkgs.shfmt
  ];

  shellHook = ''
    echo "[terraform-shell] Ready."

    if [ ! -f .pre-commit-config.yaml ]; then
      echo "Generating .pre-commit-config.yaml..."
      cat > .pre-commit-config.yaml <<'EOF'
---
repos:
  - repo: https://github.com/gfriloux/nix-precommit.git
    rev: v0.0.1
    hooks:
      - id: nix-flake-check
EOF
    else
      echo ".pre-commit-config.yaml already exists. Skipping generation."
    fi

    if [ -d .git ]; then
      if [ ! -f .git/hooks/pre-commit ]; then
        echo "Installing pre-commit hook..."
        pre-commit install -f --install-hooks
      fi
    else
      echo "Not a git repository. Skipping pre-commit installation."
    fi
  '';
}

