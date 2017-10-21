# community-pool

We presume an running Ubuntu 16.04 LTS Installation

Install necessary basic requirements:
```bash
sudo apt-get install python-software-properties
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo add-apt-repository ppa:gophers/archive
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade

sudo apt-get install golang-1.8-go nodejs nginx redis-server git nano screen
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

to be continued
