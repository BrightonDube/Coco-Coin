#!/bin/bash

set -e

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running GoatCheese   #
#################################################################
sudo apt-get update
#################################################################
# Build GoatCheese from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building GoatCheese           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/goatcheeseX
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/goatcheeseproject/goatcheeseX.git
fi

cd /usr/local/goatcheeseX/src
file=/usr/local/goatcheeseX/src/goatcheesed
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/goatcheeseX/src/goatcheesed /usr/bin/goatcheesed

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.goatcheese
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.goatcheese
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.goatcheese/goatcheese.conf
file=/etc/init.d/goatcheese
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo goatcheesed' | sudo tee /etc/init.d/goatcheese
        sudo chmod +x /etc/init.d/goatcheese
        sudo update-rc.d goatcheese defaults
fi

/usr/bin/goatcheesed
echo "GoatCheese has been setup successfully and is running..."
exit 0

