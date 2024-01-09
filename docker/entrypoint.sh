#!/bin/bash
 set -eu

BUILD_UID=$(stat -c "%u" .)

if [[ $BUILD_UID = 0 ]]; then
    BUILD_USER="root"
    BUILD_GROUP="root"
else
    BUILD_USER="mruby"
    BUILD_GROUP="mruby"

    BUILD_GID=$(stat -c "%g" .)
    groupadd -o -g $BUILD_GID $BUILD_GROUP
    useradd -o -m -u $BUILD_UID -g $BUILD_GID -s /bin/bash -d /home/$BUILD_USER $BUILD_USER
fi

case "${1:-}" in
    "shell"|"/bin/bash"|"/bin/sh"|"bash"|"sh")
        shift
        COMMAND=bash
        ;;
    *)
        COMMAND="rake -f /Rakefile"
        ;;
esac

exec gosu $BUILD_USER $COMMAND "$@"
