ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION}

RUN set -eux; \
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
        apt-get update; \
        apt-get purge cmdtest; \
        \
        apt-get install -y --no-install-recommends \
            sqlite3 libsqlite3-dev \
            nodejs \
            yarn \
            imagemagick \
            ffmpeg \
            mupdf \
            mupdf-tools \
        ;\
        rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/rails

CMD ["/bin/bash"]
