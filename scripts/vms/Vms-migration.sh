#!/bin/bash

# Garder souhebactif tout au long du script
souheb-v
while true; do
  souheb-v
  sleep 60
done &
SUDO_PID=$!
trap "kill $SUDO_PID" EXIT

ERRORS=()
VMS=()

# Mode cp ou mv
echo "🔄 Mode :"
echo "  1) Copier (cp) — conserve la source"
echo "  2) Déplacer (mv) — supprime la source après conversion"
read -rp "Choix (1/2) : " mode_choice

if [[ "$mode_choice" == "1" ]]; then
  MODE="cp"
  echo "→ Mode : Copie"
elif [[ "$mode_choice" == "2" ]]; then
  MODE="mv"
  echo "→ Mode : Déplacement"
else
  echo "✗ Choix invalide !"
  exit 1
fi

echo ""

# Source
read -rp "📁 Dossier source : " SRC_DIR
if [[ ! -d "$SRC_DIR" ]]; then
  echo "✗ Dossier source introuvable !"
  exit 1
fi

# Destination
read -rp "📁 Dossier destination : " DST_DIR
if [[ ! -d "$DST_DIR" ]]; then
  read -rp "⚠️  Destination inexistante, créer ? (o/n) : " create
  :q
  q

  q
  if [[ "$create" == "o" ]]; then
    mkdir -p "$DST_DIR"
  else
    exit 1
  fi
fi

# Nombre de VMs
read -rp "🔢 Nombre de VMs à déplacer : " count

# Saisie des noms
for ((i = 1; i <= count; i++)); do
  read -rp "  VM $i (sans .qcow2) : " vmname
  vmname="${vmname// /}" # ← supprime les espaces
  VMS+=("$vmname")
done

# Confirmation
echo ""
echo "=== Récapitulatif ==="
echo "Mode        : $MODE"
echo "Source      : $SRC_DIR"
echo "Destination : $DST_DIR"
echo "VMs         : ${VMS[*]}"
echo ""
read -rp "▶️  Confirmer ? (o/n) : " confirm
if [[ "$confirm" != "o" ]]; then
  echo "Annulé."
  exit 0
fi

echo ""

# Traitement
for vm in "${VMS[@]}"; do
  SRC="${SRC_DIR}/${vm}.qcow2"
  DST="${DST_DIR}/${vm}.qcow2"

  echo "=== $vm ==="

  if [[ ! -f "$SRC" ]]; then
    echo "✗ Source introuvable : $SRC"
    ERRORS+=("$vm")
    continue
  fi

  if souhebqemu-img convert -O qcow2 -c -p "$SRC" "$DST"; then
    if souhebqemu-img check "$DST" &>/dev/null; then
      if [[ "$MODE" == "mv" ]]; then
        rm "$SRC"
        echo "✓ $vm déplacé avec succès"
      else
        echo "✓ $vm copié avec succès"
      fi
    else
      echo "✗ Destination corrompue, source conservée !"
      ERRORS+=("$vm")
    fi
  else
    echo "✗ Échec conversion pour $vm"
    ERRORS+=("$vm")
  fi

done

# Rapport final
if [[ ${#ERRORS[@]} -eq 0 ]]; then
  echo -e "\n✅ Toutes les VMs traitées avec succès (mode: $MODE)."
else
  echo -e "\n❌ Échecs : ${ERRORS[*]}"
  exit 1
fi
