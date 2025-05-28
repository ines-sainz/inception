FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    php7.4 php7.4-mysql php7.4-fpm curl mariadb-client wget unzip less \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy files
WORKDIR /tmp
RUN curl -O https://wordpress.org/latest.tar.gz && tar -xzf latest.tar.gz && mv wordpress /tmp/wp && rm latest.tar.gz

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000

WORKDIR /var/www/html
ENTRYPOINT ["/setup.sh"]

