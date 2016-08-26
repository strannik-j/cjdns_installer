#!/bin/sh
USERNAME='user'



###############
# DO NOT EDIT #
###############
sudo echo "Start"
if (test -e /usr/bin/zypper);\
then sudo zypper install -y nodejs git libcap-progs;
else
sudo apt-get update
sudo apt-get install nodejs git build-essential libcap2-bin -y;
fi

cd /home/$USERNAME/
mkdir repo; cd repo
git clone https://github.com/cjdelisle/cjdns.git cjdns

cd /home/$USERNAME/

mkdir .scripts
echo '#!/bin/sh
cd /home/'$USERNAME'/repo/cjdns/ 
sudo -u '$USERNAME' git pull && \
sudo -u '$USERNAME' ./do && \
sudo -u root setcap "cap_net_admin+eip cap_net_raw+eip" cjdroute&& \
echo "cjdroute update DONE"' > .scripts/update-cjdroute.sh

chmod +x .scripts/update-cjdroute.sh

echo '#!/bin/sh
killall cjdroute ; 
/home/'$USERNAME'/repo/cjdns/cjdroute < /home/'$USERNAME'/repo/cjdns/cjdroute.conf' > .scripts/restart-cjdroute.sh

chmod +x .scripts/restart-cjdroute.sh

crontab -l > cron.tmp
echo '* */2 * * * /home/'$USERNAME'/.scripts/restart-cjdroute.sh' >> cron.tmp
crontab cron.tmp
rm cron.tmp

sudo crontab -l > cron.tmp
sudo echo '@daily /home/'$USERNAME'/.scripts/update-cjdroute.sh' >> cron.tmp
sudo crontab cron.tmp
sudo rm cron.tmp

/home/$USERNAME/.scripts/update-cjdroute.sh

/home/$USERNAME/repo/cjdns/cjdroute --genconf >> /home/$USERNAME/repo/cjdns/cjdroute.conf

#nano /home/$USERNAME/repo/cjdns/cjdroute.conf
N=81; sed -e $N's/^/                    # rt\
                    "91.214.242.142:52819": {\
                                "login": "default-login",\
                                "password":"g9mxq23zpvh8wrzplrmsbw1jy0wl97n",\
                                "publicKey":"xbp8fu9lyyk9ctvdjvcwk2vwn6ch7cp1307u27496nfyckqdq0t0.k",\
                                "peerName":"ryazantelecom.ru"\
                             }\
                    # Slava\
                    "92.241.12.189:22569": {\
                                "password": "6mDHySCSJYVgyJqphpgnokqKrCq045mF",\
                                "publicKey": "9qz459vnkb1v36ypq84m29g2q7dn8gndg9bh0w1499urnkx9nmt0.k",\
                                "hostname": "h.start-com.ru",\
                                "contact": "vvk@start-com.ru"\
                    }\
                    # Moscow 1\
                    "83.137.52.57:31337": {\
                                "password": "cjdnsDotixDotgs",\
                                "publicKey": "pvtgk72f25urxqywxdzfk12t2b4kuhtrc2f1mx58rtpx0wzbll90.k"\
                    }\
                    # Moscow 2\
                    "82.146.34.103:63336": {\
                                "password":"vmtgs8phs8w7t76q3zr8v7nxr4txwd1",\
                                "publicKey":"h8p5609d03yt1fzu3dlky3g1kt3bq8gffhnsbq2z1dg8j46rt4w0.k"}\
                                    }\
                    # Germany\
                    "176.9.105.201:4446": {\
                                "login":"public",\
                                "password":"ir88xwtel72fen3ch7aug603s26nu3a",\
                                "publicKey":"yrgb0xwfr9pz8swvnv6m9by8zw7v7uxxhl07qz318cjuvfgs1fc0.k",\
                                "contact":"webmaster@jazzanet.com"\
                                "location": "Germany"\
                    }\
                    # Amsterdam\
                    "95.85.46.74:47670": {\
                                "password": "freedomforallmlzb0mnd9kyz1rnall",\
                                "publicKey": "guqq5h8p9w6mtxfuh1k9hl1yqljpqqnvj2umcd1cuvx64vbuqhu0.k"}\
                                "195.34.197.189:42998":{\
                                "password": "5cvyb5mvb1pktcqhqcwjq5ng82lhjdx",\
                                "publicKey":"sn6lbr223vznkv4hr1prgxzcs7gw8fmb222huprd8zyfv617du90.k"}\
                    # Ukraine\
                    "195.34.197.189:42998":{\
                                "password": "5cvyb5mvb1pktcqhqcwjq5ng82lhjdx",\
                                "publicKey":"sn6lbr223vznkv4hr1prgxzcs7gw8fmb222huprd8zyfv617du90.k"}\
\n/' -i /home/$USERNAME/repo/cjdns/cjdroute.conf

/home/$USERNAME/.scripts/restart-cjdroute.sh
echo "Done"
cat /home/$USERNAME/repo/cjdns/cjdroute.conf | grep \"fc
