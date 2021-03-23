#!/bin/bash

PROGNAME=$(basename $0)

if test -z ${PHP_VERSION}; then
  echo "${PROGNAME}: PHP_VERSION required" >&2
  exit 1
fi

if test -z ${PHALCON_VERSION}; then
  echo "${PROGNAME}: PHALCON_VERSION required" >&2
  exit 1
fi

if test -z ${PG_CLIENT_VERSION}; then
  echo "${PROGNAME}: PG_CLIENT_VERSION required" >&2
  exit 1
fi

apt update
apt -y install \
  libpcre3-dev \
  libpng-dev \
  nfs-common \
  lsb-release \
  gnupg \
  wget \
  msmtp \
  locales \
  curl \
  sudo \
  git \
  unzip \
  tzdata \
  nano \
  awscli \
  python \
  man \
  openssl

apt -y install \
  openjdk-11-jre

SO_CODENAME=$(lsb_release -cs)
LANG=pt_BR.UTF-8
sed -i -e "s/# $LANG/$LANG/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=$LANG
locale-gen pt_BR.UTF-8
update-locale

echo "deb http://apt.postgresql.org/pub/repos/apt/" ${SO_CODENAME}-pgdg main >> /etc/apt/sources.list
wget --no-check-certificate --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
echo "deb https://packages.sury.org/php/ ${SO_CODENAME} main" | tee /etc/apt/sources.list.d/php.list

wget -qO- https://deb.nodesource.com/setup_10.x | sudo -E bash -

apt update

apt -y install \
  apache2 \
  libapache2-mod-php$PHP_VERSION \
  postgresql-client-$PG_CLIENT_VERSION

apt -y install php$PHP_VERSION-dev \
  php$PHP_VERSION \
  php$PHP_VERSION-cgi \
  php$PHP_VERSION-cli \
  php$PHP_VERSION-common \
  php$PHP_VERSION-curl \
  php$PHP_VERSION-gd \
  php$PHP_VERSION-json \
  php$PHP_VERSION-pgsql \
  php$PHP_VERSION-xml \
  php$PHP_VERSION-mbstring

apt -y install nodejs

curl -s "https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh" | bash
apt -y install php$PHP_VERSION-phalcon$PHALCON_VERSION

cd /usr/src
export HOME=/root
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

source /etc/apache2/envvars
rm /var/www/html/*

echo "<?php phpinfo(); die;" >> /var/www/html/index.php

a2enmod rewrite
a2enmod ssl
a2enmod proxy
a2enmod proxy_http