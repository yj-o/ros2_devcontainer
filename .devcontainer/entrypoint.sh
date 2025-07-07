#!/bin/bash
# shellcheck disable=SC2086
set -e

USERNAME=${USERNAME:-rdev}
USER_ID=$(id -u ${USERNAME})

if [ "$(uname -s)" != "Darwin" ]; then

    if [ "${USER_ID}" != "$(id -u)" ]; then
        echo "Changing ${USERNAME} user ID to match your host's user ID (${USER_ID})"
        usermod --uid ${USER_ID} ${USERNAME}
        find /home/${USERNAME} -user "$(id -u)" -exec chown -h ${USER_ID} {} +
    fi
fi

cd /home/${USERNAME}
gosu ${USERNAME} build_ws

if [ -z "$1" ]; then
    exec gosu ${USERNAME} /bin/bash
else
    exec gosu ${USERNAME} "$@"
fi

