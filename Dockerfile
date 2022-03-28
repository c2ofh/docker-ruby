FROM ruby:2.7.3-slim
LABEL maintainer="admin@code2order.com"

WORKDIR /app

EXPOSE 3000

# Set the locale
RUN apt-get update && \
    apt-get install -y locales

RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen de_DE.UTF-8

ENV LANG=de_DE.UTF-8 \
    LANGUAGE=de_DE:de \
    LC_ALL=de_DE.UTF-8

RUN echo "set input-meta on" >> /etc/inputrc && \
    echo "set output-meta on" >> /etc/inputrc && \
    echo "set convert-meta off" >> /etc/inputrc && \
    echo "export LANG=de_DE.utf8" >> /etc/profile && \
    cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# install bundler
RUN gem install bundler

# install some tools
RUN apt-get install -y --no-install-recommends git build-essential curl cron libpq-dev imagemagick ghostscript wget netcat nano libfontconfig1 libxrender1 shared-mime-info poppler-utils
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y --force-yes --no-install-recommends nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get --no-install-recommends install yarn

# Rails ENV
ARG RAILS_ENV=production

# BUNDLER options
ARG BUNDLER_OPTS=" --without development test"

# clean up
RUN apt-get autoremove -y

# add ffmpeg
ADD https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz  /tmp/

RUN tar -xJf /tmp/ffmpeg-release-amd64-static.tar.xz -C /tmp/ && \
    mv /tmp/ffmpeg-5.0-amd64-static/ff* /usr/local/bin && \
    rm -rf /tmp/ffmpeg*

# dummy start command
CMD ["/bin/bash"]
