#!/bin/bash

#ellamain:
screen -dmS ellaparity parity --no-ui --author="0x0000000000" --unlock="0x0000000000" --password="~/community-wallet/.walletpass" --max-peers=500 --extra-data="ella.miner" --identity="ella.miner" --cache=128 --chain "~/community-wallet/ellaism.json"

sleep 5

#pool2b:
screen -dmS ellapool2b ~/community-wallet/ellapool ~/community-wallet/pool2b.json

#api:
screen -dmS ellaapi ~/community-wallet/ellapool ~/community-wallet/api.json

#unlocker:
screen -dmS ellaunlocker ~/community-wallet/ellapool ~/community-wallet/unlocker.json

#payout:
screen -dmS ellapayout ~/community-wallet/ellapool ~/community-wallet/payout.json

#netintelligence: 
#cd ~/net-intelligence-api/ && pm2 start ~/net-intelligence-api/app.json
exit 0
