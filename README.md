This is the itty bitty service dev setup.

Most of the environment should be managed by vagrant so to begin

    vagrant up

Then, ssh into the vagrant vm (`vagrant ssh`)

Run the phoenix server from inside the project directory

	cd /vagrant/ittybitty
    mix phoenix.server
