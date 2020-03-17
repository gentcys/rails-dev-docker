# A Rails Core Development Environment in Docker

## Introduction

This project was inspired by [rails-dev-box](https://github.com/rails/rails-dev-box)

## How to Use

1. Build and start up docker containers

```
host $ docker-compose up -d
```

2. Install dependencies

```
host $ docker-compose exec workspace bash
host $ yarn install
host $ gem install bundler
host $ bundle install
```

3. Make changes to Rails core code and run test

```
host $ cd activemodel
host $ bundle exec rake test
```
