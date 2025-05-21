FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

COPY ./conf/my.cnf /etc/mysql/my.cnf

EXPOSE 3306

USER mysql

ENTRYPOINT ["/setup.sh"]
