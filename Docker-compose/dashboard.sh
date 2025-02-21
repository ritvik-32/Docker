#!/bin/bash
cd /arka-app/agent-dashboard && yarn install
yarn run build
yarn run start
tail -f /dev/null

