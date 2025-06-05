# Use the official Debian Bullseye image as the base
FROM debian:bullseye

# Update package list, install PHP 7.4 with necessary extensions and tools,
# and clean up the apt cache to reduce image size
RUN apt-get update && apt-get install -y \
    php7.4 php7.4-mysql php7.4-fpm curl mariadb-client wget unzip less \
    && rm -rf /var/lib/apt/lists/*

# Download the WP-CLI Phar (PHP archive), make it executable,
# and move it to a directory in the system PATH for global use
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set the working directory to /tmp for the next operations
WORKDIR /tmp

# Download the latest version of WordPress, extract it,
# rename the extracted folder to /tmp/wp, and remove the tarball
RUN curl -O https://wordpress.org/latest.tar.gz && tar -xzf latest.tar.gz && mv wordpress /tmp/wp && rm latest.tar.gz

# Copy the custom PHP-FPM pool configuration file into the container
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/

# Copy the setup script into the container and make it executable
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

# Expose port 9000 for FastCGI (used by PHP-FPM)
EXPOSE 9000

# Set the working directory to the web root
WORKDIR /var/www/html

# Run the setup script when the container starts
ENTRYPOINT ["/setup.sh"]
