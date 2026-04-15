*This project has been created as part of the 42 curriculum by [csenelle](https://github.com/Kamisenin)*

# Inception

## Table of Contents
- [Description](#description)
  - [Overview](#overview)
  - [Project Description](#project-description)
    - [In Depth Explanation](#in-depth-explanation)
    - [Personal note](#personal-note)
- [Instructions](#instructions)
- [Resources](#resources)

## Description

### Overview

> Inception is a project that is part of the 42 school main Cursus. It consists of a Docker infrastructure hosting a Wordpress service with a separate MariaDB database and utilities like Redis, Adminer or an FTP server. Linked under a single local domain name that is as required by the subject your login in 42 intranet ended by 42.fr

### Project Description

#### In Depth Explanation

##### Docker

###### «*What's Docker ?*» One might say. <br/>

«*Docker is a platform designed to help developers build, share, and run container applications.*» - [*Docker site*](https://www.docker.com/). Personnally I like to view it as a software that let you create multiple of little computer inside your own computer to run an application.  

Its very useful when you want to run the same operating system or application inside multiple different computer as it allows you to have the same system in every computer you create. It is basically the best option to allow anyone to run your application inside a controlled space.

The other very useful thing Docker can do is allow you to create an entire server infrastructure inside a server. This project is one of the best example of such posibility, as it is a replication of a Website and its utilities. 

Like said earlier, Docker's main purpose is to run applications inside a controlled environnment with little disk and power usage. Which is very different than VMs where the main purpose is to run an entire operating system and act as a computer inside another.

###### Secrets vs Environment Variables

One really interesting feature of Docker is Docker Secrets.  
When we want to set a Password to the application of our docker image, one of the most easy and used way to set a Dynamic password is to use environment variables. All you have to do is have a .env file and set the password inside it, then use it inside your docker-compose.yml file. But this is not the most secure way to do it. Environment variables are stored in plain text and can be accessed by anyone who has access to the container. They can be seen with a simple `docker inspect` command or by reading the /proc filesystem inside the container.

Docker Secrets on the other hand are encrypted at rest and in transit. They are only available to the services that have been granted access to them and are mounted as files inside the container at `/run/secrets/<secret_name>`. This makes them a lot more secure than environment variables as they are not exposed in the container's environment and cannot be seen with a simple inspect command.

In this project, we use Docker Secrets for sensitive data like database passwords and root passwords while keeping non-sensitive configuration like domain names or database names as environment variables.

###### Docker Network vs Host Network

Docker provides different networking modes for containers. The two most common ones are the **bridge network** (Docker Network) and the **host network**.

With the **Docker Network** (bridge mode), Docker creates an isolated virtual network for your containers. Each container gets its own IP address and they can communicate with each other through the network while being isolated from the host machine's network. You can control which ports are exposed to the outside world and which services can talk to each other. This is the mode we use in this project as it provides better isolation and security between the services.

With the **Host Network**, the container shares the host machine's network stack directly. This means the container does not get its own IP address and instead uses the host's IP. While this can be slightly faster since there is no network translation layer, it removes the network isolation between the container and the host which is not ideal for a multi-service infrastructure like ours where we want each service to be properly isolated and only communicate through defined channels.

In short, Docker Network gives you control and security while Host Network gives you simplicity and speed at the cost of isolation.

###### Docker Volumes vs Bind Mounts

When it comes to persisting data in Docker, there are two main options: **Docker Volumes** and **Bind Mounts**.

**Bind Mounts** are the simplest way to persist data. They map a directory on the host machine directly to a directory inside the container. The problem with bind mounts is that they are entirely dependent on the host machine's filesystem structure. If you move your project to another machine, the paths might not exist or might point to different locations. They also give the container full access to the host directory which can be a security concern.

**Docker Volumes** are managed entirely by Docker. They are stored in a part of the host filesystem that is managed by Docker (`/var/lib/docker/volumes/` by default) and non-Docker processes should not modify this data. Volumes are the preferred way to persist data in Docker because they are easier to back up, migrate and manage than bind mounts. They work on both Linux and Windows containers and can be safely shared among multiple containers.

In this project, we use Docker Volumes to persist the WordPress files and the MariaDB database data. This way, even if the containers are destroyed and recreated, the data remains intact and consistent.

##### Alpine

The subject of Inception requires you to choose between and Alpine or Debian distribution to use as a base for the images.
Personnally, I choose to go with Alpine for two main reasons :
I. Alpine is the fastest and most light Linux distribution of the two, which makes it a lot faster and less disk heavy to build. With my limited space of 8 GB it is very much necessary.
II. It is also one of the most used linux distribution when hosting servers and website, which may have to do with the first reason but i figured it is itself a good reason to use it when pretty much every one else uses it.  


#### Personal note
> The last bonus part requires you to add a service of your choice and justify its choice in the whole in perspective of the rest of the infrastructure. At first I wanted to add a self hosted Analytics service like Umami or Matomo but the latter did not have any CLI support at the time and I didn't have enough space in the school's VM to build Umami. So I went with another self hosted service I liked : Glance. it is a very simple, ✨ *stylish* ✨ and easy to use dashboard manager. I found it particularly interesting as it proposed a very unique docker management option that let you see the state of your dockers without having to go through docker ps inside the server while still be secured with a password. Which is a quite useful thing to have in a docker infrastructure where we would imagine it to be online, as you are not always able to directly access your dockers and see their current state.   

## Instructions

Here is a brief explanation of the available commands to manage the infrastructure. All commands are run from the root of the project using `make`.

| Command | Description |
|---------|-------------|
| `make setup` | Runs the setup script and builds then starts all containers in detached mode. This is the command to use when you want to get everything up and running for the first time. |
| `make build` | Runs the setup script and builds all the Docker images without starting the containers. Useful when you want to compile the images and check for build errors. |
| `make up` | Starts all the containers defined in the docker-compose file. Use this when the images are already built and you just want to bring the infrastructure up. |
| `make down` | Stops and removes all running containers. The volumes and images are kept intact so you can bring everything back up quickly. |
| `make clean` | Stops all containers and prunes the entire Docker system removing all unused images, containers and networks. |
| `make fclean` | The nuclear option. Stops all containers, removes volumes, orphan containers, prunes everything including volumes and deletes the persistent data directories. Use this when you want a completely fresh start. |
| `make re` | Runs `clean` followed by `setup`. A quick way to rebuild everything from scratch. |

## Resources

- [Nginx Documentation](https://nginx.org/en/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [WordPress CLI Documentation](https://developer.wordpress.org/cli/commands/)
- [Glance GitHub](https://github.com/glanceapp/glance)
- [Stéphane Music's Inception](https://music-music.music42.fr/music/inception) <!-- TODO: Replace with the correct URL -->
