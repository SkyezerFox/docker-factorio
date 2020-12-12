#!/bin/bash
set -euo pipefail

# env vars
FACTORIO_VERSION="1.0.0"
FACTORIO_SAVE_NAME="default"
FACTORIO_PORT="34197"

# test if a pre-existing server binary has been downloaded.
function has_cached_server_archive() {
    if [[ -f "factorio_headless_x64_$FACTORIO_VERSION.tar.xz" ]]; then
        return 0
    fi
    return 1
}

# check if factorio data directory exists - if it doesn't, download the latest version.
if [[ -d factorio && -f factorio/bin/x64/factorio ]]; then
    echo "UPDATER > Found pre-exisiting server data."
else
    if ! has_cached_server_archive; then
        echo "UPDATER > Downloading latest stable server version..."
        curl -OJL https://factorio.com/get-download/stable/headless/linux64
    else
        echo "UPDATER > Found an existing server binary"
    fi

    echo "UPDATER > Extracting server data..."
    ls .
    tar -xvf "factorio_headless_x64_$FACTORIO_VERSION.tar.xz"
fi

# create a new save if one does not exist.
if [[ ! -f "./saves/$FACTORIO_SAVE_NAME.zip" ]]; then
    echo "UPDATER > Creating new world in './saves/$FACTORIO_SAVE_NAME.zip...'"
    ./factorio/bin/x64/factorio --create "./saves/$FACTORIO_SAVE_NAME.zip"
fi

# start the server.
echo "UPDATER > Starting server..."
./factorio/bin/x64/factorio --start-server "./saves/$FACTORIO_SAVE_NAME.zip" $@
