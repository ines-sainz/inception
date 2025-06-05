# Use the official Debian Bullseye image as the base
FROM debian:bullseye

# Update package list, install nginx and openssl, then clean up apt cache to reduce image size
RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

# Copy the custom NGINX configuration file into the container's enabled sites directory
COPY ./conf/default.conf /etc/nginx/sites-enabled/default

# Create the directory for SSL certificates, give full permissions (for simplicity),
# and generate a self-signed SSL certificate valid for 1 year using OpenSSL
RUN mkdir /etc/nginx/certs/ && chmod 777 /etc/nginx/certs && \
	openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=localhost" \
  -out /etc/nginx/certs/localhost.crt \
  -keyout /etc/nginx/certs/localhost.key

# Expose port 443 to allow HTTPS traffic to the container
EXPOSE 443

# Start NGINX in the foreground so the container stays running
CMD ["nginx", "-g", "daemon off;"]
