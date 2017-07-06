#!/usr/bin/env bash

set -e

unzip-strip() (
    local zip=$1
    local dest=${2:-.}
    local temp=$(mktemp -d) && unzip -d "$temp" "$zip" && mkdir -p "$dest" &&
    shopt -s dotglob && local f=("$temp"/*) &&
    if (( ${#f[@]} == 1 )) && [[ -d "${f[0]}" ]] ; then
        mv "$temp"/*/* "$dest"
    else
        mv "$temp"/* "$dest"
    fi && rmdir "$temp"/* "$temp"
)

if [ -z ${PUPPET_GOGS_INSTALLATION_DIRECTORY} ]; then echo "PUPPET_GOGS_INSTALLATION_DIRECTORY not set!"; exit 1;  fi
if [ -z ${PUPPET_GOGS_OS} ]; then echo "PUPPET_GOGS_OS not set!"; exit 1;  fi
if [ -z ${PUPPET_GOGS_ARCH} ]; then echo "PUPPET_GOGS_ARCH not set!"; exit 1;  fi
if [ -z ${PUPPET_GOGS_VERSION} ]; then echo "PUPPET_GOGS_VERSION not set!"; exit 1;  fi

PUPPET_GOGS_ARCH=$(echo "${PUPPET_GOGS_ARCH}" | awk '{print tolower($0)}')
PUPPET_GOGS_OS=$(echo "${PUPPET_GOGS_OS}" | awk '{print tolower($0)}')

PUPPET_GOGS_ARCH="${PUPPET_GOGS_ARCH/x86_64/amd64}"
PUPPET_GOGS_ARCH="${PUPPET_GOGS_ARCH/i386/386}"

if [ ${PUPPET_GOGS_VERSION} == "latest" ]; then
    echo "fetching latest version"
    LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/gogits/gogs/releases/latest)
    LATEST_VERSION=$(echo ${LATEST_RELEASE} | sed -e 's/^.*"tag_name":"v\([^"]*\)".*$/\1/')
    echo "found latest version ${LATEST_VERSION}"
    PUPPET_GOGS_VERSION=${LATEST_VERSION}
fi

DOWNLOAD_ZIP_URL="https://github.com/gogits/gogs/releases/download/v${PUPPET_GOGS_VERSION}/${PUPPET_GOGS_OS}_${PUPPET_GOGS_ARCH}.zip"
DOWNLOAD_VERSION_URL="https://raw.githubusercontent.com/gogits/gogs/v${PUPPET_GOGS_VERSION}/templates/.VERSION"

if [ -f "${PUPPET_GOGS_INSTALLATION_DIRECTORY}/templates/.VERSION" ]; then

    LOCAL_VERSION=$(<"${PUPPET_GOGS_INSTALLATION_DIRECTORY}/templates/.VERSION")
    REMOTE_VERSION=$(wget -O- -q ${DOWNLOAD_VERSION_URL})

    if [ ${LOCAL_VERSION} == ${REMOTE_VERSION} ]; then
      echo "Version ${REMOTE_VERSION} already installed. skipping..."
      exit 0
    fi
fi

echo "download and extract version ${PUPPET_GOGS_VERSION}"

wget ${DOWNLOAD_ZIP_URL} -O /tmp/gogs.zip
unzip-strip /tmp/gogs.zip ${PUPPET_GOGS_INSTALLATION_DIRECTORY}

rm -f /tmp/gogs.zip
