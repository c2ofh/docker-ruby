FROM ruby:2.5.5-slim
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
RUN apt-get install -y cron build-essential git nodejs imagemagick libpq-dev wget

# Rails ENV
ARG RAILS_ENV=production

# BUNDLER options
ARG BUNDLER_OPTS=" --without development test"

# clean up
RUN apt-get autoremove -y

# dummy start command
CMD ["/bin/bash"]