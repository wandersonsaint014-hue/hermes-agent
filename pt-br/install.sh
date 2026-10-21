#!/usr/bin/env bash
set -euo pipefail
if [[ "${1:-}" == --help ]]; then
  echo 'Uso: bash pt-br/install.sh [--yes]'; echo 'Instala Hermes original em ~/.hermes-pt-br; não configura modelo nem contas.'; exit 0
fi
[[ $# == 0 || ( $# == 1 && "$1" == --yes ) ]] || { echo 'Opção inválida' >&2; exit 2; }
if [[ -n "${TERMUX_VERSION:-}" || "${OSTYPE:-}" == *android* ]]; then
  echo 'Android: use o pacote Termux oficial; consulte README.pt-BR.md. Este instalador não é para Termux.' >&2; exit 1
fi
case "$(uname -s)" in Linux|Darwin) ;; *) echo 'Use Linux, macOS compatível ou WSL2.' >&2; exit 1;; esac
[[ "$(uname -s)" != Darwin || "$(uname -m)" == arm64 ]] || { echo 'macOS Intel não é suportado pelo upstream.' >&2; exit 1; }
[[ "$(id -u)" != 0 ]] || { echo 'Execute sem root/sudo.' >&2; exit 1; }
for tool in git curl tar python3; do command -v "$tool" >/dev/null || { echo "Falta instalar: $tool" >&2; exit 1; }; done
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.hermes-pt-br"
[[ ! -e "$TARGET" ]] || { echo "$TARGET já existe. Não será sobrescrito; use apply.py para reaplicar idioma." >&2; exit 1; }
python3 - "$HOME" <<'PY'
import shutil,sys
if shutil.disk_usage(sys.argv[1]).free < 3 * 1024**3:
    sys.exit('Libere pelo menos 3 GiB antes de começar. Estimativa conservadora, não garantia de espaço suficiente.')
PY
printf '%s
' 'Será baixado e executado o instalador original fixado, com dependências e acesso à rede.' 'Ele pode solicitar dependências do sistema e modificar PATH/arquivos de inicialização do shell.' 'Sem navegador, controle do computador, desktop, modelo, contas ou gateway nesta etapa.'
if [[ "${1:-}" != --yes ]]; then
  read -r -p 'Continuar? Digite SIM: ' answer
  [[ "$answer" == SIM ]] || exit 1
fi
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
PIN=cf4f3a7396814ffcaef69d9af09f7cfdade3ddbe
curl --fail --location --proto '=https' --tlsv1.2 "https://raw.githubusercontent.com/NousResearch/hermes-agent/$PIN/scripts/install.sh" -o "$TMP/install.sh"
python3 - "$TMP/install.sh" <<'PY'
from pathlib import Path
import hashlib,sys
actual=hashlib.sha256(Path(sys.argv[1]).read_bytes()).hexdigest()
if actual != '20f44240ebada354a468104a6a6724d037afcb8883d4d09ddeb4815622c52d8b':
    sys.exit('Integridade do instalador divergente. Instalação cancelada.')
PY
HERMES_REPO_URL=https://github.com/NousResearch/hermes-agent.git bash "$TMP/install.sh" --commit "$PIN" --dir "$TARGET/hermes-agent" --hermes-home "$TARGET" --non-interactive --skip-browser --skip-computer-use
python3 "$HERE/apply.py" --home "$TARGET" --hermes "$HOME/.local/bin/hermes"
echo 'Configuração concluída. Leia README.pt-BR.md antes de escolher modelo e ferramentas.'
