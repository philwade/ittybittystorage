[![Build Status](https://travis-ci.org/philwade/ittybittystorage.svg?branch=master)](https://travis-ci.org/philwade/ittybittystorage)

This is the itty bitty service dev setup.
Because of issues with vagrant I've been just doing local dev, which requires you to be running postgres and redis. Please see the config
directory for how to configure environment variables to connect to them.

## Releasing

Itty bitty storage is using Distillery and Docker to build releases! Neat! 👏

This process is for my server, running CentOS 7, so your mileage may vary. This is mostly written so I don't forget 🙃

Releasing requires a set of env variables to be available:

    RECAPTCHA_PUBLIC_KEY=123fakekey
	RECAPTCHA_PRIVATE_KEY=456notakeystyx
	REDIS_URI=redis://localhost:666
	PORT=9000

It also requires you to set production postgres connection values, unless they match what's in `config/dev.exs`.
I do this with a `config/secret.prod.exs` file.

To build a release run:

    docker/build.sh

The release will be in the `_build` folder.

## Deprecated

Sorry, the vagrant stuff isn't really working because of an issue with Cowboy and file system syncing.
Most of the environment should be managed by vagrant so to begin

    $ vagrant up

Then, ssh into the vagrant vm (`vagrant ssh`). All commands below are run *inside* the vagrant vm.

I still haven't figured out how to make vagrant install Hex in the right place, so the first time you boot the vm, you need to run:

    $ mix local.hex

The first time you run, you may need to install dependencies:

	$ cd /vagrant/ittybitty
    $ mix deps.get
	$ npm install

Run the phoenix server from inside the project directory

	$ cd /vagrant/ittybitty
    $ mix phoenix.server

Visit http://localhost
