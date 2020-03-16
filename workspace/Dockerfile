ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION}

RUN set -eux; \
        apt-get update; \
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

CMD ["/bin/bash"]
