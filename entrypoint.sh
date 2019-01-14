#!/bin/bash

wg-quick up ${INTERFACE}

while sleep 20; do
    date -R
    wg show
done
