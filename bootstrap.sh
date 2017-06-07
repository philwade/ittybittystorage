#!/usr/bin/env bash

DB_PASS=password

# install necessary modules
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
#apt-get install -y apache2 mysql-server
#apt-get install -y php5 php5-curl php5-gd php5-mysql php5-common php5-mcrypt

apt-get install -y git curl

wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo add-apt-repository -y ppa:chris-lea/redis-server

apt-get update
apt-get install -y esl-erlang
apt-get install -y elixir
apt-get install -y postgresql
apt-get install -y redis-server

sudo apt-get install -y nodejs

cat << EOF | su - postgres -c psql
ALTER USER postgres WITH ENCRYPTED PASSWORD '$DB_PASS';
CREATE DATABASE ittybitty_dev;
EOF

su - vagrant -c "yes | mix local.hex && yes | mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez"
