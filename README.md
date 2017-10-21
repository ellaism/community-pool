# community-pool

We presume an running Ubuntu 16.04 LTS Installation

The ELLA Community pool contains a pre-build binary with 50% Community share to the community wallet. If you don't want to do these donations you have to change the unlocker.json to donate => false but we hope that you will share it with the community.


Install necessary basic requirements:
```bash
sudo apt-get install python-software-properties
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo add-apt-repository ppa:gophers/archive
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade

sudo apt-get install golang-1.8-go nodejs nginx redis-server git nano screen dpkg wget fail2ban iptables iptables-persistent
```

Now we clone the repo into your home-folder ~ :
```bash
cd ~
git clone https://github.com/ellaism/community-pool
```

We are going into the www folder now and install basic requirements there:
```bash
cd ~/community-pool/www/
npm install -g ember-cli@2.9.1
npm install -g bower
npm install
bower install
./build.sh
```

your homepath can be shown with these command:
```bash
cd ~
pwd
```
the output is your homepath

Now we are setting the nginx to the pool. Open a fresh default config in nano:
```bash
rm /etc/nginx/sites-available/default
nano /etc/nginx/sites-available/default
```

Now fill in these config into the nginx config: 
```bash
server {
        listen 0.0.0.0:80;

        root <your home path>/community-pool/www/dist;
        index index.html index.htm;

        server_name ella.yourdomain.example;

        location /api {
                proxy_pass http://127.0.0.1:8080;
        }

        location / {
                try_files $uri $uri/ /index.html;
        }
}
```

Save it and restart the nginx:
```bash
service nginx restart
```

now we make the necessary files executable:
```bash
chmod +x ~/community-pool/ellapool
chmod +x ~/community-pool/poolstart.sh
```

download the parity deb and install it: 
```bash
wget https://parity-downloads-mirror.parity.io/v1.8.1/x86_64-unknown-linux-gnu/parity_1.8.1_amd64.deb
dpkg -i ./x86_64-unknown-linux-gnu/parity_1.8.1_amd64.deb
```

now create a password file and write a password in, your server wallet will use:
```bash
nano ~/community-pool/.walletpass

```

now you create your server wallet:
```bash
parity account new --password="~/community-pool/.walletpass"
```

copy the output and fill it into 3 files:

poolstart.sh in the startup of parity 2 times:
```bash
nano ~/community-pool/poolstart.sh
```

payout.json at the end of the config file in "payouts" > "address":
```bash
nano ~/community-pool/payout.json
```

unlocker.json at the end of the config file in "unlocker" > "poolfeeaddress"
```bash
nano ~/community-pool/unlocker.json
```

now we are ready and start the pool the first time:
```bash
~/community-pool/poolstart.sh
```

we look if all processes are basically online, to do this use:
```bash
screen -list
```
you should see all screens of all pool processes in the output, then you can go on... 

now we implement some basic security while the parity is syncing in the background.

fail2ban is still running, nevertheless, to make it harder to attack you we change the ssh port now:
```bash
nano /etc/ssh/sshd_config

Set Port to something you can remember, e.g.:
Port 2288
```
save it, close nano, restart ssh
```bash
service restart ssh
```

Please remember, the next time you have to connect yourself to the new SSH port too! 

Now we set some simple iptables rules to drop all other shit away, presuming 2288 for ssh as for now:
