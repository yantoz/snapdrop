#!/bin/sh

trap 'kill -TERM $PID' TERM INT

npm i

if [ "${SINGLE_ROOM}" -eq "1" ]; then
    echo "Activating single room mode ..."
    sed -i 's/peer.ip/0/g' /app/server/index.js
    sed -i 's/sender.ip/0/g' /app/server/index.js
fi

node index.js &
PID=$!

nginx 
wait $PID

EXIT_STATUS=$?

