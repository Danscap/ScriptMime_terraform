#! /bin/bash


#Install


# SUBLIME TEXT

curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"

sudo apt install sublime-text -y


# wendy

cd /home/danscap/
git clone https://github.com/z3bra/wendy.git
cd wendy/
make
make install

#node

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs



