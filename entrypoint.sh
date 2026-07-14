#!/bin/bash
#
# Use steamcmd to install the specific server set via the APP_ID
# environment variable.
#
# To force validation of existing files, set DO_VALIDATE to 1. To skip the
# updating of the existing files, set SKIP_UPDATE to 1.
#
# APP_ID and APP_NAME must both be set.
#
# The script, /start-server.sh, must exist.
#
set -eu

DO_VALIDATE="${DO_VALIDATE:-0}"
SKIP_UPDATE="${SKIP_UPDATE:-0}"

# Verify APP_ID and APP_NAME are set and start-server.sh exists.
if [[ -z "$APP_ID" ]]; then
    echo "error: APP_ID is not set."
    exit 1
elif [[ -z "$APP_NAME" ]]; then
    echo "error: APP_NAME is not set."
    exit 1
elif [[ ! -f /start-server.sh ]]; then
    echo "error: /start-server.sh does not exist."
    exit 1
fi

if [[ $SKIP_UPDATE -eq 0 ]]; then
    echo "Installing/updating $APP_NAME ($APP_ID) into $INSTALL_DIR ..."
    STEAMCMD_OPTS=(
        +force_install_dir "$INSTALL_DIR" +login anonymous +app_update $APP_ID
    )
    [[ $DO_VALIDATE -eq 1 ]] && STEAMCMD_OPTS+=(validate)
    STEAMCMD_OPTS+=(+quit)

    /usr/games/steamcmd "${STEAMCMD_OPTS[@]}"
fi

echo "Starting dedicated server"
cd "$INSTALL_DIR"
bash /start-server.sh
