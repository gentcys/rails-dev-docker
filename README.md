# A Rails Core Development Environment in Docker

## Introduction

This project was inspired by [rails-dev-box](https://github.com/rails/rails-dev-box)

## Requirements

* Docker

## How to Build

    host $ docker build --no-cache -t rails-dev-docker .

## Recommended workflow

* Clone your Rails fork into the rails-dev-docker directory on the host computer:

    `cd rails-dev-docker && git clone https://github.com/<your username>/rails.git`

    `host $ docker run -v /Users/<your username>/rails-dev-docker/rails:/home/rails/rails -d --name rails-dev-docker rails-dev-docker`

* Enter the running container:
	
    Install gems  
    `$ su rails && cd /home/rails/rails && bundle install`  
    Create postgresql user.  
    `$ createuser --superuser rails`.  
    Create databases in mysql and postgresql.  
    `$ bundle exec rake db:create`.  
    Execute test  
    `$ bundle exec rake test`
