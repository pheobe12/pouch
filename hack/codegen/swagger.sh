#!/usr/bin/env bash

set -euo pipefail

readonly SWAGGER_VERSION=v0.19.0
readonly arch=$(uname -m)

# swagger::check_version checks the command and the version.
swagger::check_version() {
  local has_installed version

  has_installed="$(command -v swagger || echo false)"
  if [[ "${has_installed}" = "false" ]]; then
    echo false
    return
  fi

  version="$(swagger version | head -n 1 | cut -d " " -f 2)"
  if [[ "${SWAGGER_VERSION}" != "${version}" ]]; then
    echo false
    return
  fi
  echo true
}

# swagger::install installs the swagger binary.
swagger::install() {
  echo ">>>> install swagger-${SWAGGER_VERSION} <<<<"
  local url
  
  if [[ "${arch}" == "aarch64" ]]; then
    arch1="arm64"
  else
    arch1="amd64"
  fi
  url="https://github.com/go-swagger/go-swagger/releases/download/${SWAGGER_VERSION}/swagger_linux_${arch1}"

  wget --quiet -O /usr/local/bin/swagger "${url}"
  chmod +x /usr/local/bin/swagger
}
