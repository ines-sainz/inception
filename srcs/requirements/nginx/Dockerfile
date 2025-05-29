FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/sites-enabled/default

RUN mkdir /etc/nginx/certs/ && chmod 777 /etc/nginx/certs && \
	openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=localhost" \
  -out /etc/nginx/certs/localhost.crt \
  -keyout /etc/nginx/certs/localhost.key

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
