# A Rails Core Development Environment in Docker

## Introduction

This project was inspired by [rails-dev-box](https://github.com/rails/rails-dev-box)

## How to Build

    host $ docker build --no-cache -t rails-dev-docker .

## Recommended workflow

* Pull the image

        host $ docker pull gentcys/rails-dev-docker
        host $ mkdir -p rails-dev-docker

* Clone your Rails fork into the rails-dev-docker directory on the host computer:

        host $ cd rails-dev-docker
        host $ git clone https://github.com/<your username>/rails.git

        host $ docker run -v /Users/<your username>/rails-dev-docker/rails:/home/rails/rails -d --name rails-dev-docker rails-dev-docker

* Enter the running container:

    Install gems

        $ su rails
        $ cd /home/rails/rails
        $ bundle install
        $ exit

    Create postgresql user

        $ su postgres
        $ createuser --superuser rails
        $ exit

    Create databases in mysql and postgresql

        $ su rails
        $ cd $HOME/rails/activerecord
        $ bundle exec rake db:create

    Execute test

        $ bundle exec rake test
