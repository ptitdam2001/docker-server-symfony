# Dockerizing Apache - PHP5 based on Ubuntu lastest
FROM ubuntu:latest

MAINTAINER Damien Suhard <dsuhard@gmail.com>

# Install
RUN apt-get -y upgrade
RUN apt-get update && \
	apt-get -y install curl \
	apache2  \
	php5 \
	libapache2-mod-php5 \
	php5-mysql \
	php5-curl \
	php5-mcrypt \
	php5-gd && \
	rm -rf /var/lib/apt/lists/*

#download and configure Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
#RUN sed -i "s/date.timezone = \"Europe/Paris\"/date.timezone = \"Europe/Paris\"/" /etc/php5/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
 
EXPOSE 80

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
 
# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND