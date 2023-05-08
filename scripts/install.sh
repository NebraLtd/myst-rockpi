# fix missing signature for radxa repos
export DISTRO=buster-stable
curl apt.radxa.com/$DISTRO/public.key | sudo apt-key add -
apt-get update

# isntall mysterium
curl https://raw.githubusercontent.com/mysteriumnetwork/node/master/install.sh | sudo bash

# copy files
cp myst_update.sh /opt/
chmod +x /opt/myst_update.sh

cp services/*.service /lib/systemd/system/
cp services/*.timer /lib/systemd/system/

# enable service mysterium update service
systemctl enable mysterium-update.timer
# this shouldn't be needed after adding timer, doens't hurt
systemctl enable mysterium-update.service
# enable system upgrade service
systemctl enable os_upgrader.timer