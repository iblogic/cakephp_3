FROM php:7.2.0RC1-apache

# Timezone
ENV TIMEZONE Europe/London
ENV PHP_MEMORY_LIMIT 1024M
ENV MAX_UPLOAD 128M
ENV PHP_MAX_FILE_UPLOAD 128
ENV PHP_MAX_POST 128M

RUN apt-get update -q && apt-get install -qqy \
	git-core \
	composer \ 
	#Installing mod-php installs both recommended PHP 7 and Apache2
	libapache2-mod-php \
	php-mcrypt \
	php-mbstring \
	php-zip \
	php-xml \
	php-codesniffer \
	&& rm -rf /var/lib/apt/lists/*
	
RUN apt-get update \
	&& apt-get install -y git zlib1g-dev libicu-dev g++ \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl \
	&& docker-php-ext-install pdo pdo_mysql zip
	
RUN docker-php-ext-install mysqli
	
# Enable mod rewrite and listen to localhost
RUN a2enmod rewrite

# Set workdir (no more cd from now)
WORKDIR /var/www/html
VOLUME /var/www/html

# Expose port and run Apache webserver  
EXPOSE 80
CMD ["apache2-foreground"]