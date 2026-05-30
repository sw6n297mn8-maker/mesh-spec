#!/bin/bash
# Hook SessionStart: prepara o toolchain do mesh-spec em sessoes Claude Code na web.
#
# Garante que `go`, `cue` e `python3` estejam disponiveis para rodar a validacao
# do projeto (`cue vet ./...`, export de CLAUDE.md/README, scripts de CI em
# scripts/ci/*.py). A versao do CUE e fixada para casar com cue.mod/module.cue
# e com o CI (.github/workflows/validate.yml: cue-lang/setup-cue v0.16.0).
#
# Idempotente: pode rodar multiplas vezes sem efeito colateral. Nao-interativo.
set -euo pipefail

# Versao canonica do CUE (fonte: cue.mod/module.cue language.version + CI).
CUE_VERSION="v0.16.0"

# Roda apenas no ambiente remoto (Claude Code na web). Localmente, no-op.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# --- Go ---
# Go vem pre-provisionado na imagem base da web. Apenas verificamos a presenca;
# nao tentamos reinstalar do zero dentro do hook.
if ! command -v go >/dev/null 2>&1; then
  echo "ERRO: toolchain Go nao encontrado no ambiente." >&2
  echo "      O mesh-spec instala o CUE CLI via 'go install' e depende do Go." >&2
  exit 1
fi
echo "go: $(go version)"

# Diretorio onde 'go install' deposita binarios. Garante no PATH desta sessao
# e persiste para o restante da sessao via CLAUDE_ENV_FILE.
GOBIN_DIR="$(go env GOBIN)"
[ -z "$GOBIN_DIR" ] && GOBIN_DIR="$(go env GOPATH)/bin"
export PATH="$GOBIN_DIR:$PATH"
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  PATH_LINE="export PATH=\"$GOBIN_DIR:\$PATH\""
  # Append apenas se ainda nao registrado (idempotente entre eventos SessionStart).
  if ! { [ -f "$CLAUDE_ENV_FILE" ] && grep -qF "$PATH_LINE" "$CLAUDE_ENV_FILE"; }; then
    echo "$PATH_LINE" >> "$CLAUDE_ENV_FILE"
  fi
fi

# --- CUE CLI ---
# Instala o CUE na versao fixada se ausente ou em versao divergente.
need_install=true
if command -v cue >/dev/null 2>&1; then
  if cue version 2>/dev/null | grep -q "${CUE_VERSION#v}"; then
    echo "cue: ja instalado ($(cue version 2>/dev/null | head -1))"
    need_install=false
  else
    echo "cue: versao divergente, reinstalando ${CUE_VERSION}..."
  fi
fi
if [ "$need_install" = true ]; then
  echo "Instalando CUE ${CUE_VERSION} via go install (cuelang.org/go/cmd/cue)..."
  go install "cuelang.org/go/cmd/cue@${CUE_VERSION}"
  echo "cue: $(cue version 2>/dev/null | head -1)"
fi

# --- Python 3 ---
# Usado pelos scripts de CI em scripts/ci/*.py (apenas stdlib; sem deps externas).
if ! command -v python3 >/dev/null 2>&1; then
  echo "ERRO: python3 nao encontrado (necessario para scripts/ci/*.py)." >&2
  exit 1
fi
echo "python3: $(python3 --version)"

echo "Toolchain do mesh-spec pronto (go + cue + python3)."
