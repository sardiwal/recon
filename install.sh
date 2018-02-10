git clone https://github.com/aboul3la/Sublist3r
	cd Sublist3r
	sudo pip install -r requirements.txt
	cd ..

git clone https://github.com/rbsec/dnscan

git clone https://github.com/ChrisTruncer/EyeWitness
	cd EyeWitness
	sh setup/setup.sh
	cd ..

wget https://sourceforge.net/projects/dirb/files/dirb/2.22/dirb222.tar.gz/download
tar zxvf dirb222.tar.gz
cd dirb
chmod u+x configure
./configure

cd ..

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
brew install nikto

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install nmap

