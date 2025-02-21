#!/bin/bash
cd /arka-app/playground && yarn install
yarn run build
yarn run start
tail -f /dev/null
