#!/bin/bash

#ellamain:
screen -dmS ellaparity parity --no-ui --author="0x0000000000" --unlock="0x0000000000" --password="~/community-pool/.walletpass" --max-peers=500 --extra-data="ella.miner" --identity="ella.miner" --cache=128 --chain "~/community-pool/ellaism.json"

sleep 5

#pool2b:
screen -dmS ellapool2b ~/community-pool/ellapool ~/community-pool/pool2b.json

#api:
screen -dmS ellaapi ~/community-pool/ellapool ~/community-pool/api.json

#unlocker:
screen -dmS ellaunlocker ~/community-pool/ellapool ~/community-pool/unlocker.json

#payout:
screen -dmS ellapayout ~/community-pool/ellapool ~/community-pool/payout.json

#netintelligence: 
#cd ~/net-intelligence-api/ && pm2 start ~/net-intelligence-api/app.json
exit 0
