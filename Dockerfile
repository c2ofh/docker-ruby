FROM ruby:2.6.5-alpine
LABEL maintainer="admin@code2order.com"

WORKDIR /app

EXPOSE 3000

ENV MUSL_LOCPATH="/usr/share/i18n/locales/musl"

RUN apk --no-cache add libintl && \
	apk --no-cache --virtual .locale_build add cmake make musl-dev gcc gettext-dev git && \
	git clone https://gitlab.com/rilian-la-te/musl-locales && \
	cd musl-locales && cmake -DLOCALE_PROFILE=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install && \
	cd .. && rm -r musl-locales && \
	apk del .locale_build

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
RUN apk add --no-cache cron build-essential git imagemagick libpq-dev wget netcat nano nodejs yarn

RUN yarn install --check-files

# Rails ENV
ARG RAILS_ENV=production

# BUNDLER options
ARG BUNDLER_OPTS=" --without development test"

# clean up
#RUN apt-get autoremove -y

# add ffmpeg
ADD https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz  /tmp/

RUN tar -xJf /tmp/ffmpeg-release-amd64-static.tar.xz -C /tmp/ && \
    mv /tmp/ffmpeg-4.2.2-amd64-static/ff* /usr/local/bin && \
    rm -rf /tmp/ffmpeg*

# dummy start command
CMD ["/bin/bash"]

