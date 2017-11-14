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
```

now you want to edit the main config file for the js web:
```bash
nano ~/community-pool/www/config/environment.js
```
here you change the domain in the APP: { } Block to yours 

now we make the necessary files executable:
```bash
chmod +x ~/community-pool/ellapool
chmod +x ~/community-pool/poolstart.sh
chmod +x ~/community-pool/www/build.sh
```

after you have done this you want to compile your poolweb now:
```bash
cd ~/community-pool/www/
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
```bash
nano /etc/iptables/rules.v4
```
fill in there some basic rules:
```bash
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]

# Accepts all established inbound connections
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# Allows all outbound traffic
# You could modify this to only allow certain traffic, you don't want to unless you know what you are doing!
-A OUTPUT -j ACCEPT
# Allow all localhost source traffic ie, your proxie stuff from ember
-A INPUT -s 127.0.0.1/32 -j ACCEPT
# Allow pool connections from anywhere
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 8002 -j ACCEPT
-A INPUT -p tcp --dport 8822 -j ACCEPT
# Allows SSH connections 
# The --dport number is the same as in /etc/ssh/sshd_config you changed before
-A INPUT -p tcp -m state --state NEW --dport 2288 -j ACCEPT
# Allow ping
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
# log iptables denied calls (access via 'dmesg' command)
-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7
# Reject all other inbound - default deny unless explicitly allowed policy:
-A INPUT -j REJECT
-A FORWARD -j REJECT

COMMIT

```
save it, then you can activate it, and write reformatted back to the file:
```bash
 iptables-restore < /etc/iptables/rules.v4
 iptables-save > /etc/iptables/rules.v4
```

Now you can open your browser and point it to your pool domain. 

Congratulations, you've setup your first own pool.

Now point a worker to it and try out the function of the pool.

We recommend that you have a look into the new Eminer Project, cause this has still really nice functions with the builtin dashboard and free cloud service.

Now to the daily things. We still looked into the screen -list one time. 
The screen processes there have self explaining names. 
So start with looking into the parity screen to see parity working:
```
screen -r ellaparity
```
DON'T DO ctrl+c or something under any circumstances, cause this will close the screen session and stop the process!!!

To detach from the screen session and go back to your starting shell use the Key-Combination:
```
CTRL + a (at same time, then release completely and press quick) d 
```

You have to train this. The most people who haven't worked with screen until now have problems the first minutes to hit the right combination and speed of the keystrokes. Train it. Really, just do it now. Train it, train it, TRAIN IT! It will work without any problems as soon as you know how to do this key combination. But again, DON'T PRESS something like ctrl + c or such under any circumstances cause it will kill your process!!!

Now, you have done the hardest part. Look into screen -list and look into the running processes and what they do. This will be your main job now, to hold these processes running. Good luck. :-) 

Cheers

Chris 

Teams Minerpool.net / Pirl.io / Ellaism.com


P.S.:
Please keep in mind, that beeing a good pool operator is a full time job with supporting the miners, supporting the pool, solving problems, keeping the security, and so on. 

You should get a shh key and change ssh to only allow the login with a key instead of password authentication. Furthermore you should read more about linux server security and linux server backups, especially for a backup of the redis database you are using now.  


