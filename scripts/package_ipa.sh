#!/usr/bin/env bash
set -euo pipefail

APP_PATH="${1:-}"
OUT_IPA="${2:-}"

if [[ -z "${APP_PATH}" || -z "${OUT_IPA}" ]]; then
  echo "Usage: scripts/package_ipa.sh <path-to-.app> <output.ipa>" >&2
  exit 2
fi

if [[ ! -d "${APP_PATH}" || "${APP_PATH}" != *.app ]]; then
  echo "Error: APP_PATH must be an existing .app directory: ${APP_PATH}" >&2
  exit 2
fi

OUT_DIR="$(cd "$(dirname "${OUT_IPA}")" && pwd)"
OUT_IPA_ABS="${OUT_DIR}/$(basename "${OUT_IPA}")"
mkdir -p "${OUT_DIR}"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

mkdir -p "${WORK_DIR}/Payload"
cp -R "${APP_PATH}" "${WORK_DIR}/Payload/"

(
  cd "${WORK_DIR}"
  /usr/bin/zip -qry "${OUT_IPA_ABS}" Payload
)

echo "Wrote: ${OUT_IPA_ABS}"
