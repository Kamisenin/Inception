*This project has been created as part of the 42 curriculum by [csenelle](https://github.com/Kamisenin)*

# Inception

## Table of Contents
    - (Description)[#description]

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

###### Secrets

One really interesting feature of Docker is Docket Secrets.  
When we want to set a Password to the application of our docker image, one of the most easy and used way to set a Dynamic password is to use environment variables. All you have to do is have a .env file and

##### Alpine

The subject of Inception requires you to choose between and Alpine or Debian distribution to use as a base for the images.
Personnally, I choose to go with Alpine for two main reasons :
I. Alpine is the fastest and most light Linux distribution of the two, which makes it a lot faster and less disk heavy to build. With my limited space of 8 GB it is very much necessary.
II. It is also one of the most used linux distribution when hosting servers and website, which may have to do with the first reason but i figured it is itself a good reason to use it when pretty much every one else uses it.  


#### Personal note
> The last bonus part requires you to add a service of your choice and justify its choice in the whole in perspective of the rest of the infrastructure. At first I wanted to add a self hosted Analytics service like Umami or Matomo but the latter did not have any CLI support at the time and I didn't have enough space in the school's VM to build Umami. So I went with another self hosted service I liked : Glance. it is a very simple, ✨ *stylish* ✨ and easy to use dashboard manager. I found it particularly interesting as it proposed a very unique docker management option that let you see the state of your dockers without having to go through docker ps inside the server while still be secured with a password. Which is a quite useful thing to have in a docker infrastructure where we would imagine it to be online, as you are not always able to directly access your dockers and see their current state.   
