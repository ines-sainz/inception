# Use the official Debian Bullseye image as the base image
FROM debian:bullseye

# Update the package lists, install MariaDB server and client,
# then clean up apt cache to reduce image size
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Create the directory for MariaDB runtime files and set ownership to the mysql user
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Copy the setup script from the host machine into the container root
COPY ./tools/setup.sh /setup.sh

# Make the setup script executable
RUN chmod +x /setup.sh

# Copy a custom MariaDB configuration file into the container
COPY ./conf/my.cnf /etc/mysql/my.cnf

# Expose port 3306 (default port for MySQL/MariaDB) to allow external connections
EXPOSE 3306

# Switch to the mysql user to run the container as a non-root user
USER mysql

# Set the container's entrypoint to the setup script
ENTRYPOINT ["/setup.sh"]
