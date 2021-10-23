#!/bin/sh

trap 'kill -TERM $PID' TERM INT

npm i

if [ "${SINGLE_ROOM}" -eq "1" ]; then
    echo "Activating single room mode ..."
    sed -i 's/peer.ip/0/g' /app/server/index.js
    sed -i 's/sender.ip/0/g' /app/server/index.js
fi
if [ "${DISABLE_RTC}" -eq "1" ]; then
    echo "Disabling RTC ..."
    sed -i 's/window.isRtcSupported = .*/window.isRtcSupported = false;/' /app/client/scripts/network.js
fi
if [ "${WS_RELAY}" -eq "1" ]; then
    echo "Enable websocket relay ..."
    sed -i 's/window.isWSRelayEverything = .*/window.isWSRelayEverything = true;/' /app/client/scripts/network.js
fi

node index.js &
PID=$!

nginx 
wait $PID

EXIT_STATUS=$?

