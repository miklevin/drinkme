# Standard bash file for doing late-stage apt installs

figlet -t Installing Google Chrome
sudo apt-get install libxss1 libappindicator1 libindicator7 -y
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome*.deb -y
sudo apt install x11-apps -y

# Install Microsoft Playright browsers, edited out in favor of Chrome
playwright install

