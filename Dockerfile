FROM ubuntu:latest
MAINTAINER Phil Wade "phil@philwade.org"

#RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get install -y git curl wget

# Erlang dependencies
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb

# Node deps
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get update
RUN apt-get install -y esl-erlang elixir postgresql redis-server nodejs

RUN yes | mix local.hex && yes | mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

ENV MIX_ENV dev
ADD ittybitty /home/ittybitty

WORKDIR /home/ittybitty
EXPOSE 4000
CMD ["mix", "phoenix.server"]
