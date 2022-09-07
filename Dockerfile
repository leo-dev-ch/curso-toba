# Imagen Base
  FROM debian:10

  RUN apt-get update
  RUN apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg gnupg2 gnupg1 curl
  RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
  RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
  RUN apt-get update && apt-get install -y

  RUN apt-get -y install mc nano git
  RUN apt-get install -y php7.3 php7.3-cli php7.3-common php7.3-pgsql php7.3-soap php7.3-ldap php7.3-xsl php7.3-mysqli php7.3-bcmath php7.3-zip php7.3-gd php7.3-mbstring php7.3-gmp php7.3-curl php7.3-xsl
  RUN apt-get install -y  apache2 libapache2-mod-php7.3

  RUN cp /etc/php/7.3/apache2/php.ini /etc/php/7.3/apache2/php.ini.original
  RUN cp /etc/php/7.3/cli/php.ini /etc/php/7.3/cli/php.ini.original

# Configuración de apache
  COPY php.ini /etc/php/7.3/apache2/php.ini
  COPY php.ini /etc/php/7.3/cli/php.ini

  #RUN apt-get install -y openjdk-8-jre openjdk-8-jre-headless
  RUN a2enmod rewrite
  RUN a2enmod setenvif

#Yarn
  RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add -
  RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list
  RUN apt-get update && apt-get install yarn -y


  
#composer
  RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  RUN php composer-setup.php
  RUN php -r "unlink('composer-setup.php');"
  RUN mv composer.phar /usr/local/bin/composer

  EXPOSE 80
  CMD /usr/sbin/apache2ctl -D FOREGROUND
