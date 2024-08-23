#!/bin/bash
set +e

LINTER_NAME="markdownlint-cli2"
MARKDOWNLINT_PARAMS=()
MARKDOWNLINT_FILE_PATERN=()
MARKDOWNLINT_VERSION="${MARKDOWNLINT_VERSION:-latest}"
MARKDOWNLINT_CONFIG_FILE="${MARKDOWNLINT_CONFIG_FILE:-}"

read -r -a MARKDOWNLINT_FILE_PATERN <<< "${FILE_PATTERN:-**/*.md}"

# Check if markdownlint-cli2 is installed
if [[ ! -f "$(command -v markdownlint-cli2 || true)" ]]; then
  echo "::group:: Installing markdownlint-cli2 ..."
  npm install "markdownlint-cli2@${MARKDOWNLINT_VERSION}" --global
  echo "::endgroup::"
fi

# Check if config files exists
if [[ -n "${MARKDOWNLINT_CONFIG_FILE}" ]]; then
  if [[ ! -f "${MARKDOWNLINT_CONFIG_FILE}" ]]; then
    echo "::error title=${LINTER_NAME}::Config file not found: ${MARKDOWNLINT_CONFIG_FILE}"
    exit 1
  else
    MARKDOWNLINT_PARAMS+=( "--config" "${MARKDOWNLINT_CONFIG_FILE}" )
  fi
fi

# Run markdownlint-cli2
echo "::group::📝 Running markdownlint-cli2 ..."
markdownlint-cli2 "${MARKDOWNLINT_FILE_PATERN[@]}" "${MARKDOWNLINT_PARAMS[@]}" ; exit_code=$?
echo "::endgroup::"
exit "${exit_code}"
