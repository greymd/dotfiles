#!/bin/bash -xv

# Dependencies
# * fswatch
#   $ brew install fswatch

THIS_DIR=$(cd $(dirname $0) && pwd)
SEMAPHORE="/tmp/automake.$$"

while ps $$ > /dev/null ; do
    sleep 1
    [ -e "$SEMAPHORE" ] || continue
    rm -f "$SEMAPHORE"
    $THIS_DIR/gradlew build
done &

fswatch --event=Updated $THIS_DIR/src/ | while read $line;
do
    touch "$SEMAPHORE"
done

