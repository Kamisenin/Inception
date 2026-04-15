# Inception — User & Administrator Documentation

## Table of Contents

- [Services Overview](#services-overview)
- [Starting and Stopping the Project](#starting-and-stopping-the-project)
  - [Make Commands Reference](#make-commands-reference)
- [Accessing the Services](#accessing-the-services)
  - [WordPress](#wordpress)
  - [Adminer](#adminer)
  - [Glance Dashboard](#glance-dashboard)
  - [Welcome Page](#welcome-page)
  - [FTP Server](#ftp-server)
- [Managing Credentials](#managing-credentials)
- [Checking Service Health](#checking-service-health)
  - [Using the Command Line](#using-the-command-line)
  - [Using the Glance Dashboard](#using-the-glance-dashboard)

---

## Services Overview

The Inception stack deploys the following services, each running in its own isolated Docker container on a shared bridge network named `inception` :

| Service | Container Name | Description |
|---------|---------------|-------------|
| **Nginx** | `nginx` | Reverse proxy and TLS termination point. Handles all incoming HTTPS traffic on port 443 and routes requests to the appropriate backend service. |
| **WordPress** | `wordpress` | The main web application. Served through PHP-FPM on port 9000, accessible via Nginx. |
| **MariaDB** | `mariadb` | Relational database storing all WordPress data (posts, users, settings, etc.). |
| **Redis** | `redis` | In-memory cache used by WordPress to speed up page loads and reduce database queries. |
| **Adminer** | `adminer` | Lightweight database administration interface. Allows you to browse and manage the MariaDB database from a web browser. |
| **FTP** | `ftp` | VSFTPD file transfer server. Provides FTP access to the WordPress files for direct file management. |
| **Glance** | `glance` | Self-hosted dashboard that displays the real-time state of every container in the stack. Protected by password. |
| **Static Page** | `static_page` | A simple static welcome page served independently from WordPress. |

All services restart automatically on failure (`restart: on-failure`).

---

## Starting and Stopping the Project

Before running any command, make sure you are at the **root of the project repository** (where the `Makefile` is located).

### Make Commands Reference

| Command | What It Does | When to Use It |
|---------|-------------|----------------|
| `make setup` | Runs the initial setup script (`setup.sh`) to create the required data directories, then builds every Docker image and starts all containers in detached mode (`-d`). This is the primary entry point. | First time setup, or when you want to build and start everything in one step. |
| `make build` | Runs the setup script and builds all Docker images **without** starting any container. | When you want to verify that all images compile correctly before bringing the stack up. |
| `make up` | Starts all containers as defined in `docker-compose.yml`. Does **not** rebuild images. | When images are already built and you simply want to bring the infrastructure back online. |
| `make down` | Stops and removes all running containers. Volumes and images remain on disk so the next `make up` is fast. | When you want to temporarily shut down the stack without losing any data or built images. |
| `make clean` | Runs `make down` first, then executes `docker system prune -af` to remove **all** unused Docker images, containers and networks from the system. Volumes are preserved. | When you want to free disk space occupied by old or dangling images while keeping your persistent data. |
| `make fclean` | Stops all containers, removes volumes and orphan containers (`docker compose down -v --remove-orphans`), prunes the entire Docker system including volumes, and deletes the persistent data directories on the host. **This is destructive and irreversible.** | When you need a completely clean slate — all data, images and volumes will be deleted. |
| `make re` | Runs `make clean` followed by `make setup`. Equivalent to a full rebuild from scratch while preserving data directories. | When you want to rebuild every image and restart the stack quickly. |

---

## Accessing the Services

All web-facing services are exposed through the Nginx reverse proxy over **HTTPS on port 443**. The domain name used below is the one you configured in your `.env` file and in `/etc/hosts` (e.g. `csenelle.42.fr`).

### WordPress

| | |
|---|---|
| **URL** | `https://<your_domain>/` |
| **Admin Panel** | `https://<your_domain>/wp-admin` |
| **Description** | The main WordPress website. Log in to the admin panel with the WordPress administrator credentials defined in the `.env` file (`WORDPRESS_ADMIN` / `WORDPRESS_ADMIN_PASSWORD`). |

### Adminer

| | |
|---|---|
| **URL** | `https://<your_domain>/adminer/` |
| **Description** | Web-based database management tool. Use it to browse tables, run SQL queries, or export/import data. Connect using the MariaDB credentials from your `.env` file (`WP_DB_USER` / `WP_DB_USER_PASSWD`, server: `mariadb`). |

### Glance Dashboard

| | |
|---|---|
| **URL** | `https://<your_domain>/glance/` |
| **Description** | Real-time dashboard showing the status of every container in the stack. Protected by the credentials defined in the `.env` file (`GLANCE_ADMIN` / `GLANCE_PASSWD`). |

### Welcome Page

| | |
|---|---|
| **URL** | `https://<your_domain>/welcome/` |
| **Description** | A static HTML page served independently from WordPress. No authentication required. |

### FTP Server

| | |
|---|---|
| **Host** | `<your_domain>` |
| **Port** | `21` |
| **Passive Ports** | `21210–21220` |
| **Description** | VSFTPD server providing access to the WordPress files. Connect with any FTP client (e.g. FileZilla) using the FTP credentials from your `.env` file (`FTP_USER` / `FTP_PASSWD`). |

---

## Managing Credentials

All credentials and configuration variables are centralized in a single environment file located at :

```
srcs/.env
```

This file is loaded by Docker Compose and injected into the containers that require it. Below is a summary of the variables and their purpose :

| Section | Variable | Purpose |
|---------|----------|---------|
| **Database** | `DB_ROOT_PASSWD` | MariaDB root password. |
| | `WP_DB_NAME` | Name of the WordPress database. |
| | `WP_DB_USER` | Database user for WordPress. |
| | `WP_DB_USER_PASSWD` | Password of the WordPress database user. |
| **WordPress** | `WORDPRESS_ADMIN` | WordPress administrator username. |
| | `WORDPRESS_ADMIN_PASSWORD` | WordPress administrator password. |
| | `WORDPRESS_ADMIN_EMAIL` | WordPress administrator email address. |
| | `WORDPRESS_USER` | A secondary WordPress user (editor/author). |
| | `WORDPRESS_USER_EMAIL` | Email of the secondary user. |
| | `WORDPRESS_USER_PASSWD` | Password of the secondary user. |
| | `WORDPRESS_TITLE` | Title displayed on the WordPress site. |
| **FTP** | `FTP_USER` | FTP login username. |
| | `FTP_PASSWD` | FTP login password. |
| **Glance** | `GLANCE_ADMIN` | Glance dashboard administrator name. |
| | `GLANCE_PASSWD` | Glance dashboard password. |
| **Volumes** | `DATA_PATH` | Absolute path on the host where persistent data (database, WordPress files) is stored. |

> **Important :** The `.env` file contains sensitive information. Do not commit it to a public repository. If you need to share the project, use the `env_example` file as a template and let each user create their own `.env` from it.

To modify any credential, edit the `.env` file and rebuild the affected containers :

```bash
# Edit credentials
nano srcs/.env

# Rebuild and restart
make re
```

---

## Checking Service Health

### Using the Command Line

**List all running containers and their current state :**

```bash
docker ps
```

This displays each container's name, image, status (e.g. `Up 2 minutes (healthy)`), and exposed ports. All containers should show a status of `Up`. The MariaDB container additionally reports a `(healthy)` status when its built-in healthcheck passes.

**View live logs for all services :**

```bash
docker compose -f srcs/docker-compose.yml logs
```

**View logs for a specific service :**

```bash
docker compose -f srcs/docker-compose.yml logs <service_name>
```

Replace `<service_name>` with one of : `mariadb`, `wordpress`, `nginx`, `redis`, `adminer`, `ftp`, `glance`, `static_page`.

**Follow logs in real time (useful for debugging) :**

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

### Using the Glance Dashboard

If you prefer a graphical overview, navigate to `https://<your_domain>/glance/` in your browser. After authenticating with the Glance credentials, the dashboard displays the real-time state of every container in the stack (running, stopped, restarting, etc.) without requiring terminal access. This is particularly useful when you cannot directly access the server through SSH.