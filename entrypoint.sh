#!/bin/bash

wg-quick up ${INTERFACE}

wg show

finish () {
    echo "$(date): Shutting down Wireguard"
    wg-quick down ${INTERFACE}
    exit 0
}

trap finish SIGTERM SIGINT SIGQUIT

while true; do sleep 86400; done &
wait $!
