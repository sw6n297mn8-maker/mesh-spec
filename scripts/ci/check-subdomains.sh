#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

export MESH_REPO_ROOT="$REPO_ROOT"

cd "$REPO_ROOT/tools/governance/subdomains"
go run . "$@"
