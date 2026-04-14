#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
# Lucioles — helper de développement local Supabase
# ═══════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

usage() {
  echo -e "${BLUE}Usage:${NC} $0 <commande>"
  echo ""
  echo "Commandes disponibles :"
  echo "  start       Démarre le stack Supabase local (Docker requis)"
  echo "  stop        Arrête le stack"
  echo "  reset       Réinitialise la DB + rejoue les migrations + seed"
  echo "  status      Affiche l'état du stack et les URLs"
  echo "  keys        Affiche les clés locales (URL, anon key)"
  echo "  studio      Ouvre Supabase Studio dans le navigateur"
  echo "  ip          Affiche l'IP locale (pour appareil physique)"
  echo "  run-ios     Lance l'app Flutter sur le simulateur iOS (dev local)"
  echo "  run-android Lance l'app Flutter sur l'émulateur Android (dev local)"
  echo "  run-device  Lance l'app Flutter sur un vrai appareil (WiFi)"
}

cmd_start() {
  echo -e "${GREEN}▶ Démarrage du stack Supabase local...${NC}"
  cd "$PROJECT_DIR"
  supabase start
  echo ""
  cmd_keys
}

cmd_stop() {
  echo -e "${YELLOW}■ Arrêt du stack Supabase local...${NC}"
  cd "$PROJECT_DIR"
  supabase stop
}

cmd_reset() {
  echo -e "${YELLOW}↺ Réinitialisation de la DB (migrations + seed)...${NC}"
  cd "$PROJECT_DIR"
  supabase db reset
  echo -e "${GREEN}✓ DB réinitialisée.${NC}"
  echo "Utilisateur de test : test@lucioles.dev / lucioles2024"
}

cmd_status() {
  cd "$PROJECT_DIR"
  supabase status
}

cmd_keys() {
  cd "$PROJECT_DIR"
  echo -e "${BLUE}── Connexions locales ───────────────────────────────${NC}"
  supabase status 2>/dev/null | grep -E "API URL|anon key|Studio URL|Inbucket" || true
}

cmd_studio() {
  open "http://127.0.0.1:54323" 2>/dev/null || xdg-open "http://127.0.0.1:54323"
}

cmd_ip() {
  local ip
  ip=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}')
  echo -e "${BLUE}IP locale (WiFi) :${NC} $ip"
  echo ""
  echo "Pour un appareil physique sur le même réseau :"
  echo "  Modifie .env.local → FLUTTER_SUPABASE_URL=http://$ip:54321"
  echo "  puis : $0 run-device"
}

cmd_run_ios() {
  cd "$PROJECT_DIR"
  echo -e "${GREEN}▶ flutter run (iOS Simulator, backend local)...${NC}"
  flutter run --dart-define-from-file=.env.local
}

cmd_run_android() {
  cd "$PROJECT_DIR"
  # L'émulateur Android accède à localhost via 10.0.2.2
  local tmp_env
  tmp_env=$(mktemp)
  sed 's|http://127.0.0.1:54321|http://10.0.2.2:54321|g' .env.local > "$tmp_env"
  echo -e "${GREEN}▶ flutter run (Android Emulator, backend local)...${NC}"
  flutter run --dart-define-from-file="$tmp_env"
  rm -f "$tmp_env"
}

cmd_run_device() {
  cd "$PROJECT_DIR"
  local ip
  ip=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}')
  echo -e "${GREEN}▶ flutter run (appareil physique → $ip)...${NC}"
  echo "Assure-toi que .env.local pointe sur http://$ip:54321"
  flutter run --dart-define-from-file=.env.local
}

# ── Dispatcher ──────────────────────────────────────────────────────────────
case "${1:-}" in
  start)       cmd_start ;;
  stop)        cmd_stop ;;
  reset)       cmd_reset ;;
  status)      cmd_status ;;
  keys)        cmd_keys ;;
  studio)      cmd_studio ;;
  ip)          cmd_ip ;;
  run-ios)     cmd_run_ios ;;
  run-android) cmd_run_android ;;
  run-device)  cmd_run_device ;;
  *)           usage ; exit 1 ;;
esac
