FROM phusion/baseimage:latest

ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8

ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV TERM xterm

RUN apt-get update && apt-get -y install --no-install-recommends \
                              bash \
                              git \
                              curl \
                              zlib1g-dev \
                              build-essential \
                              libssl-dev \
                              libreadline-dev \
                              libyaml-dev \
                              libxml2-dev \
                              libxslt1-dev \
                              libcurl4-openssl-dev \
                              libncurses5-dev \
                              libncursesw5-dev \
                              python-software-properties \
                              libffi-dev \
                              nodejs \
                              sqlite3 \
                              libsqlite3-dev \
                              memcached \
                              redis-server \
                              mysql-server \
                              mysql-client \
                              libmysqlclient-dev \
                              postgresql \
                              postgresql-client \
                              postgresql-contrib \
                              libpq-dev \
                              libmagickwand-dev \
                              ffmpeg \
                              mupdf-tools \
                              imagemagick \
                              graphicsmagick

# Use /bin/bash instead of /bin/sh
SHELL ["/bin/bash", "-c"]

# Add a system user
RUN useradd -r -m rails
USER rails
WORKDIR /home/rails

# Install rbenv
RUN git clone --depth 1 https://github.com/rbenv/rbenv.git /home/rails/.rbenv
ENV PATH /home/rails/.rbenv/shims:/home/rails/.rbenv/bin:$PATH
RUN echo 'export PATH="/home/rails/.rbenv/bin:$PATH"' >> /home/rails/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> /home/rails/.bashrc
RUN . /home/rails/.bashrc

# Install rbenv plugin rbenv-build
RUN mkdir -p /home/rails/.rbenv/plugins
RUN git clone --depth 1 https://github.com/rbenv/ruby-build.git /home/rails/.rbenv/plugins/ruby-build

# Install gems without documents
RUN echo 'gem: --no-document' > /home/rails/.gemrc

# Install Ruby programming language
RUN rbenv install 2.4.3
RUN rbenv global 2.4.3
RUN gem install bundler
RUN rbenv rehash

# Specified the mountpoint while run the container: docker run -v (directory):/home/rails/rails
VOLUME /home/rails/rails

USER root
WORKDIR /

######## Setup MySQL ########
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld
COPY my.cnf /etc/mysql/my.cnf
COPY mysql_setup.sh /etc/my_init.d/mysql_setup.sh
RUN chmod +x /etc/my_init.d/mysql_setup.sh

######## Set MySQL Daemon ########
RUN mkdir /etc/service/mysql
COPY mysql.sh /etc/service/mysql/run
RUN chmod +x /etc/service/mysql/run

######### Setup PostgreSQL #######
RUN mkdir -p /usr/local/pgsql/data
RUN chown postgres:postgres /usr/local/pgsql/data
RUN su - postgres -c '/usr/lib/postgresql/9.5/bin/initdb -A trust -D /usr/local/pgsql/data/ -U postgres'

######### Setup PostgreSQL Daemon ########
RUN mkdir /etc/service/postgres
COPY postgres.sh /etc/service/postgres/run
RUN chmod +x /etc/service/postgres/run

######### Setup Memcached Daemon #########
RUN touch /var/log/memcached.log
RUN chown -R memcache:memcache /var/log/memcached.log
RUN mkdir /etc/service/memcached
COPY memcached.sh /etc/service/memcached/run
RUN chmod +x /etc/service/memcached/run

######### Setup Redis Daemon #############
RUN touch /var/log/redis-server.log
RUN chown -R redis:redis /var/log/redis-server.log
RUN mkdir /etc/service/redis
COPY redis.sh /etc/service/redis/run
RUN chmod +x /etc/service/redis/run

######### Redis
RUN sed 's/^stop-writes-on-bgsave-error yes/stop-writes-on-bgsave-error no/' -i /etc/redis/redis.conf

CMD ["/sbin/my_init"]
