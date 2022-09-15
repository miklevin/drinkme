cls
@echo off 
echo.
echo This will install Ubuntu 18.04 on WSL to host LXD Linux containers.
echo You must wsl --unregister Ubuntu-18.04 if there's an existing one.
set /p warning=Press Enter to continue.%
echo.

REM wsl --install --distribution Ubuntu-18.04
REM wsl --shutdown

set wsluer="ubuntu"
set password="foo"

ubuntu1804 install --root

REM create user account
wsl -u root useradd -m "%wsluer%"
wsl -u root sh -c "echo "%wsluer%:%password%" | chpasswd" # wrapped in sh -c to get the pipe to work
wsl -u root  chsh -s /bin/bash "%wsluer%"
wsl -u root usermod -aG adm,cdrom,sudo,dip,plugdev "%wsluer%"

ubuntu1804 config --default-user "%wsluer%"

REM echo.
REM echo Have you set an Ubuntu username and password? If so, close
REM echo the Ubuntu window now (leave this window open) and press Enter
REM set /p warning=Press enter to continue...
REM echo.

mkdir %USERPROFILE%\repos
rmdir /S /Q %USERPROFILE%\repos\temp
mkdir %USERPROFILE%\repos\temp
wsl --set-default-version 2
wsl --set-default Ubuntu-18.04
wsl -u root -e echo -e "[automount]\n"options = \"metadata\" > wsl.conf
wsl -u root -e mv wsl.conf /etc/
wsl -u root -e ln -s /mnt/c/Users/%USERNAME%/.ssh/ /home/ubuntu/.ssh
wsl -u root -e ln -s /mnt/c/Users/%USERNAME%/repos/ /home/ubuntu/repos

wsl --shutdown
wsl -e bash -lic "cp /mnt/c/Users/%USERNAME%/.gitconfig /home/ubuntu/"
wsl -e bash -lic "cp /mnt/c/Users/%USERNAME%/.vimrc /home/ubuntu/"

wsl -u root -e curl -L -o /home/ubuntu/repos/temp/install.sh "https://raw.githubusercontent.com/nullpo-head/wsl-distrod/main/install.sh"
wsl -u root -e chmod 777 /home/ubuntu/repos/temp/install.sh
wsl -u root -e chown ubuntu:ubuntu /home/ubuntu/repos/temp/install.sh
wsl -u root -e /home/ubuntu/repos/temp/install.sh install
wsl -u root -e /opt/distrod/bin/distrod enable

wsl -u root -- lxd init --auto
wsl -u root -e curl -L -o /home/ubuntu/repos/temp/install.sh "https://raw.githubusercontent.com/miklevin/jupyme/main/install.sh"
wsl -u root -e chmod 777 /home/ubuntu/repos/temp/install.sh
wsl -u root -e chown ubuntu:ubuntu /home/ubuntu/repos/temp/install.sh
wsl -u root -e /home/ubuntu/repos/temp/install.sh

set /p warning=Done! Hit Enter to dismiss install script.
