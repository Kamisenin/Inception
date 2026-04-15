# Inception — Developer Documentation

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Setup](#environment-setup)
  - [Configuration File](#configuration-file)
  - [Domain Name Resolution](#domain-name-resolution)
- [Building and Launching the Project](#building-and-launching-the-project)
  - [Makefile Targets](#makefile-targets)
  - [Docker Compose Direct Usage](#docker-compose-direct-usage)
- [Managing Containers and Volumes](#managing-containers-and-volumes)
  - [Container Commands](#container-commands)
  - [Volume Commands](#volume-commands)
  - [Network Commands](#network-commands)
- [Data Storage and Persistence](#data-storage-and-persistence)
  - [Volume Definitions](#volume-definitions)
  - [DATA_PATH](#data_path)
  - [Persistence Behaviour](#persistence-behaviour)
- [Service Architecture](#service-architecture)
- [Customising the Glance Dashboard](#customising-the-glance-dashboard)

---

## Prerequisites

The following tools must be installed on the host machine before working on the project:

| Tool | Minimum Version | Purpose |
|------|----------------|---------|
| **Docker Engine** | 20.10+ | Container runtime. |
| **Docker Compose** (v2 plugin) | 2.0+ | Multi-container orchestration via the `docker compose` command. |
| **GNU Make** | 3.81+ | Build automation through the project Makefile. |
| **sudo** access | — | Required by `make fclean` to remove host data directories and by `/etc/hosts` editing. |
| **Git** | — | Source control. |

Ensure the Docker daemon is running before executing any command:

```bash
sudo systemctl start docker
```

---

## Environment Setup

### Configuration File

All runtime variables (database credentials, WordPress accounts, FTP credentials, Glance credentials, volume paths) are defined in a single environment file:

```
srcs/.env
```

An example template is provided at `srcs/env_example`. To configure the project:

1. Copy the template:

   ```bash
   cp srcs/env_example srcs/.env
   ```

2. Open `srcs/.env` and set every variable to the desired value. The file is organised into the following sections:

   | Section | Variables | Description |
   |---------|-----------|-------------|
   | **DB** | `DB_ROOT_PASSWD`, `WP_DB_NAME`, `WP_DB_USER`, `WP_DB_USER_PASSWD` | MariaDB root password and WordPress database credentials. |
   | **WordPress** | `WORDPRESS_ADMIN`, `WORDPRESS_ADMIN_PASSWORD`, `WORDPRESS_ADMIN_EMAIL`, `WORDPRESS_USER`, `WORDPRESS_USER_EMAIL`, `WORDPRESS_USER_PASSWD`, `WORDPRESS_TITLE` | WordPress administrator and regular user accounts, site title. |
   | **FTP** | `FTP_USER`, `FTP_PASSWD` | VSFTPD login credentials. |
   | **Glance** | `GLANCE_ADMIN`, `GLANCE_PASSWD` | Glance dashboard authentication. |
   | **Volumes** | `DATA_PATH` | Absolute path on the host where persistent data directories are created (see [DATA_PATH](#data_path)). |

3. Save the file. Docker Compose reads it automatically through the `env_file: .env` directive in `docker-compose.yml`. The Makefile also sources it via `include srcs/.env` to export `DATA_PATH`.

> **Security note:** Never commit the `.env` file containing real credentials to a public repository. The provided `env_example` contains placeholder values.

### Domain Name Resolution

The Nginx reverse proxy listens on port 443 and expects a specific `server_name` (defined in `srcs/requirements/nginx/conf/server.conf`). The host machine must resolve that domain to `127.0.0.1` (or the appropriate local IP).

1. Open `/etc/hosts` with root privileges:

   ```bash
   sudo nano /etc/hosts
   ```

2. Add a line mapping your chosen domain to a local address. For example:

   ```
   127.0.42.1    csenelle.42.fr
   ```

   The first three octets should remain unchanged from your existing loopback configuration; the last octet can be set freely. The domain must match the `server_name` in the Nginx configuration.

3. Save and close the file. The domain now resolves locally.

---

## Building and Launching the Project

### Makefile Targets

All commands must be run from the **repository root** (where the `Makefile` is located).

| Target | Command | Description |
|--------|---------|-------------|
| `setup` | `make setup` | Runs `setup.sh` to create the required host directories (`${DATA_PATH}/data/db`, `${DATA_PATH}/data/wordpress`, etc.), then builds all Docker images and starts every container in detached mode (`docker compose up -d --build`). This is the standard first-run command. |
| `build` | `make build` | Runs `setup.sh` and builds all images without starting containers. Useful when you only want to verify that all Dockerfiles compile correctly. |
| `up` | `make up` | Starts all services in the foreground using the existing images. Does not rebuild. Container logs are printed directly to the terminal. Press `Ctrl+C` to stop. |
| `down` | `make down` | Stops and removes all running containers. Images and volumes remain on disk, making the next `make up` fast. |
| `clean` | `make clean` | Calls `make down`, then runs `docker system prune -af` to remove all unused images, stopped containers and dangling networks. Volumes are **not** deleted. |
| `fclean` | `make fclean` | Stops all containers, removes volumes and orphans (`docker compose down -v --remove-orphans`), prunes the entire Docker system including volumes, and **deletes the host data directories** at `${DATA_PATH}/data` with `sudo rm -rf`. This is destructive and irreversible. |
| `re` | `make re` | Runs `make clean` followed by `make setup`. Equivalent to a full teardown and rebuild. |

All targets are declared `.PHONY` so they always execute regardless of filesystem state.

### Docker Compose Direct Usage

The Makefile wraps Docker Compose with the variable:

```makefile
DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml
```

If you need more granular control, you can invoke Docker Compose directly. Examples:

```bash
# Build a single service
docker compose -f srcs/docker-compose.yml build wordpress

# Start only specific services (and their dependencies)
docker compose -f srcs/docker-compose.yml up mariadb wordpress nginx

# Restart a single container without affecting the rest
docker compose -f srcs/docker-compose.yml restart redis

# View the resolved Compose configuration
docker compose -f srcs/docker-compose.yml config
```

---

## Managing Containers and Volumes

### Container Commands

| Command | Description |
|---------|-------------|
| `docker ps` | List all running containers with their status, ports and names. |
| `docker ps -a` | Include stopped containers. |
| `docker logs <container_name>` | Print the logs of a specific container. Add `-f` to follow in real time. |
| `docker exec -it <container_name> sh` | Open an interactive shell inside a running container. All images are Alpine-based, so `sh` is available (not `bash`). |
| `docker inspect <container_name>` | Display detailed configuration and state information in JSON format. |
| `docker compose -f srcs/docker-compose.yml logs` | Print aggregated logs for all services. |
| `docker compose -f srcs/docker-compose.yml logs -f` | Follow aggregated logs in real time. |
| `docker compose -f srcs/docker-compose.yml logs <service>` | Print logs for a single service (e.g. `mariadb`, `wordpress`, `nginx`). |

### Volume Commands

| Command | Description |
|---------|-------------|
| `docker volume ls` | List all Docker-managed volumes. |
| `docker volume inspect <volume_name>` | Show the mount point and driver details for a volume. |
| `docker volume rm <volume_name>` | Remove a specific volume (container must be stopped first). |
| `docker volume prune` | Remove all unused volumes. |

### Network Commands

| Command | Description |
|---------|-------------|
| `docker network ls` | List all Docker networks. The project uses a bridge network named `inception`. |
| `docker network inspect inception` | Show connected containers, IP addresses and network configuration. |

---

## Data Storage and Persistence

### Volume Definitions

The project declares three volumes in `docker-compose.yml`:

| Volume | Mount Path (inside container) | Host Path | Purpose |
|--------|-------------------------------|-----------|---------|
| `db-data` | `/var/lib/mysql` (mariadb) | `${DATA_PATH}/data/db` | MariaDB database files. |
| `wp-data` | `/var/www/html` (wordpress, nginx, ftp) | `${DATA_PATH}/data/wordpress` | WordPress application files (themes, plugins, uploads). |
| `shared-config` | `/shared` (wordpress) | Docker-managed (no host bind) | Ephemeral shared configuration between services. |

The `db-data` and `wp-data` volumes use the `local` driver with a `bind` mount option, meaning they map directly to directories on the host filesystem. The `shared-config` volume is a standard Docker-managed volume with no host binding.

### DATA_PATH

`DATA_PATH` is defined in `srcs/.env` and exported by the Makefile. It controls the root directory on the host where persistent data is stored. The directory structure created by `setup.sh` is:

```
${DATA_PATH}/
└── data/
    ├── db/           ← MariaDB data files
    └── wordpress/    ← WordPress files (wp-content, plugins, themes, uploads)
```

To change the storage location, update `DATA_PATH` in `srcs/.env` before running `make setup`. If the project has already been built with a different path, run `make fclean` first to remove the old data, then update the variable and run `make setup` again.

### Persistence Behaviour

- **Containers are ephemeral.** Running `make down` and `make up` destroys and recreates containers, but the data in the volumes remains untouched.
- **`make clean`** removes images but preserves volumes. Data survives.
- **`make fclean`** removes everything — volumes, images and the host data directories. All data is permanently deleted.

---

## Service Architecture

The following diagram summarises how containers relate to each other:

```
                    ┌───────────────────────────────────┐
                    │           Host Machine             │
                    │                                   │
  Port 443 ──────▶ │   ┌───────────┐                   │
                    │   │   Nginx   │ (reverse proxy)   │
                    │   └─────┬─────┘                   │
                    │         │                         │
          ┌────────┼─────────┼────────────┐            │
          │        │         │            │            │
          ▼        │         ▼            ▼            │
   ┌───────────┐   │  ┌───────────┐ ┌──────────┐      │
   │  Adminer  │   │  │ WordPress │ │  Static  │      │
   │ /adminer/ │   │  │     /     │ │ /welcome/│      │
   └─────┬─────┘   │  └─────┬─────┘ └──────────┘      │
         │         │        │                          │
         │         │   ┌────┴────┐                     │
         │         │   │         │                     │
         ▼         │   ▼         ▼                     │
   ┌───────────┐   │ ┌─────┐ ┌───────┐                │
   │  MariaDB  │◀──┼─┤     │ │ Redis │                │
   │  (db-data)│   │ └─────┘ └───────┘                │
   └───────────┘   │                                   │
                    │   ┌───────┐    ┌───────┐          │
                    │   │  FTP  │    │ Glance│          │
                    │   │  :21  │    │/glance/│         │
                    │   └───────┘    └───────┘          │
                    └───────────────────────────────────┘
```

All containers are connected to the `inception` bridge network. Only Nginx exposes port 443 to the host. Glance accesses the Docker daemon via the mounted `/var/run/docker.sock` socket to read container states.

---

## Customising the Glance Dashboard

The Glance dashboard configuration is located at:

```
srcs/bonus/glance/conf/glance.yml
```

This YAML file controls the dashboard layout, widgets, authentication and server settings. It is copied into the container image at build time (`/var/glance/glance.yml`).

To modify the dashboard:

1. Edit `srcs/bonus/glance/conf/glance.yml`.
2. Rebuild the Glance container:

   ```bash
   docker compose -f srcs/docker-compose.yml build glance
   docker compose -f srcs/docker-compose.yml up -d glance
   ```

For the full list of available widgets, configuration options and examples, refer to the official Glance documentation:

- [Glance Configuration Reference](https://github.com/glanceapp/glance/blob/main/docs/configuration.md)
- [Glance Widget Documentation](https://github.com/glanceapp/glance/blob/main/docs/configuration.md#widgets)