# Inception Project

> **A Docker-based system administration project for building a secure web infrastructure using Docker and Docker Compose.**

## 🌍 What is Inception?

**Inception** is a project that demonstrates how to design, implement, and secure a mini web infrastructure using Docker containers.
It is designed to introduce containerization, service orchestration, and basic system administration.

The project simulates hosting a WordPress website behind a secure NGINX proxy with a MariaDB backend inside a Virtual Machine.
Everything runs in isolated Docker containers, communicating through a dedicated network, with attention to security, automation, and data persistence.

---

## 🎓 What Is Learned

* How to use Docker and Docker Compose
* How to write and configure Dockerfiles
* Create and configure Docker images from scratch
* Using Docker Compose to orchestrate multi-container setups
* Set up a secured multi-service web infrastructure
* Securely exposing services and handling TLS/SSL
* Managing data persistence with volumes
* Manage volumes and environment variables
* Automating deployments with Makefiles
* Following best practices in container design
* How to automate the deployment of real-world web services

---

## 🔧 Project Structure

```
.
├── Makefile                   # Builds and starts everything
├── srcs/
│   ├── .env                   # Environment variables (not committed)
│   ├── docker-compose.yml     # Defines services, volumes, and network
│   └── requirements/
│       ├── nginx/             # NGINX config and Dockerfile
│       ├── wordpress/         # WordPress config, setup and Dockerfile
│       └── mariadb/           # MariaDB config, setup and Dockerfile

```

---

## 🚀 Infrastructure Overview

This project sets up the following services:

### 1. **NGINX**

* Acts as the **only entry point** to your infrastructure.
* It has to be accessed via a domain name in the format: `isainz-r.42.fr`
* This domain should point to the local IP of your virtual machine.
* Configured to support HTTPS only (TLSv1.2 or TLSv1.3).
* Uses a self-signed SSL certificate.
* Forwards traffic securely to the WordPress backend.

### 2. **WordPress**

* Deployed using php-fpm, **without** its own web server (nginx).
* Contains a fully functional WordPress site.
* Automatically configured with a title, admin user, and second user.
* Hosted files must be served through volumes.

### 3. **MariaDB**

* Hosts the WordPress database.
* Secured with a custom root password and user credentials.

All services run in separate containers and are built using **custom Dockerfiles**, not pre-built images (except for the base OS: Debian).

---

## 📊 Key Features

### 💡 Containerization

* Each service runs in its own container.
* Services are connected via a **custom Docker network**.
* **No** use of `host` network or deprecated linking options.
* The `docker-compose.yml` must define a custom network, named volumes and Services and their Dockerfiles.

### ⚖️ Security and Best Practices

* Everything must be run in a **Virtual Machine** (e.g., Debian Bullseye).
* A `Makefile` located at the root directory must automate the full build and deployment process using `docker compose`.
* Containers must be able to **restart automatically** on crash.
* All configuration and source files must reside inside a folder called `srcs/`.
* NGINX is the only exposed container (on port 443).
* SSL enforced with strict protocol version.
* **Passwords and secrets** stored outside the Dockerfiles.
* Use of `.env` files to store environment variables.
* No use of infinite loops or hacky process holds (e.g., `tail -f`).
* Use proper daemon handling (understand `PID 1`).

### 💾 Persistence

* Two volumes are used:

  * One for WordPress files
  * One for MariaDB data
* Data persists even after containers are stopped or recreated.

