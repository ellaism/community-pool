#!/bin/bash

#ellamain:
screen -dmS ellaparity parity --no-ui --author="0x0000000000" --unlock="0x0000000000" --password="/home/ella/.walletpass" --max-peers=500 --extra-data="ella.miner" --identity="ella.miner" --cache=128 --chain "/home/ella/ellaism.json"

sleep 5

#pool2b:
screen -dmS ellapool2b /home/ella/ellapool /home/ella/pool2b.json

#api:
screen -dmS ellaapi /home/ella/ellapool /home/ella/api.json

#unlocker:
screen -dmS ellaunlocker /home/ella/ellapool /home/ella/unlocker.json

#payout:
screen -dmS ellapayout /home/ella/ellapool /home/ella/payout.json

#netintelligence: pm2 start /home/ella/net-intelligence-api/app.json
exit 0
