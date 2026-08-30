# Homebrew formula for the ovh-ops console.
#
# This file is GENERATED from packaging/homebrew/ovh-ops.rb.in by
# hack/update-tap.sh — never edit the tap formula by hand.
class OvhOps < Formula
  desc "Console ops unifiée pour OVH cloud et kube (TUI k9s-like + CLI)"
  homepage "https://github.com/ctn-solutions/ovh-ops"
  # Tarball de release (stable, checksummé) — pas l'archive source auto-générée.
  url "https://github.com/ctn-solutions/ovh-ops/releases/download/v4.4.0/ovh-ops-4.4.0.tar.gz"
  sha256 "3a05225b36e643a028bc5547ebec85c6981984e2b3735372e6ee286b7be82f9a"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Le script résout son package via realpath : script et ovhops/ doivent
    # rester côte à côte — installés dans libexec, symlink dans bin.
    libexec.install "ovh-ops", "ovhops"
    # Shebang → python3 de Homebrew (le env python3 du PATH peut être absent
    # ou trop vieux).
    inreplace libexec/"ovh-ops", "#!/usr/bin/env python3",
              "#!#{Formula["python@3.12"].opt_bin/"python3"}"
    bin.install_symlink libexec/"ovh-ops"
  end

  def caveats
    <<~EOS
      La console lit les credentials OVH dans un fichier tfvars :

        export OVH_OPS_TFVARS=/chemin/vers/terraform.tfvars

      Prérequis runtime : kubectl (contextes configurés) et gh (authentifié)
      pour certaines commandes. Mise à jour : brew upgrade ou `ovh-ops update`
      (refusé en installation Homebrew — passer par brew).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ovh-ops version")
  end
end
