FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/sites-enabled/default
COPY ./tools/localhost.crt /etc/nginx/certs/localhost.crt
COPY ./tools/localhost.key /etc/nginx/certs/localhost.key

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
