# tanks_of_freedom_docker_server
Tanks of Freedom Server, running in Docker.

## About Tanks of Freedom Server
https://github.com/P1X-in/tanks-of-freedom-server#readme

# Getting Started

## TOF Server Stack is Code + DB

TOF server requires both its code and a mysql/mariadb database where it persists application data.

Respecting Docker's single process per container principle, the application and the database are run in separate containers.
As a result, they must be configured to "speak" to each other.

### Pre-Flight Configurations: THE SERVER

#### config.py
This file contains configurable sections for maps, and the database:  
```bash
# database configuration
MYSQL_HOST = 'tof_db'
MYSQL_USER = 'user'
MYSQL_PASSWORD = 'pass'
MYSQL_DB = 'tof'
```
Whatever is set in these variables, should align with your database container via CLI or docker-compose methods. In the supplied
`docker-compose.yml` file, the database container is exposed, but not ported. This keeps the database away from the internet, while
remaining accessible to the application container via their container names or aliases as supplied by the `links:` argument.

#### Build the Server's Docker Image

From the repo directory, locally:
```
$ docker build -f $PWD/Dockerfile -t tof/server:latest .
```

### Pre-Flight Configurations: THE DATABASE
You can go through this process of building the database independently of the stack, or you can just run the compose file
from here, and the database pre-flight will auto-build. To engage the auto-build now, run:  

```bash
$ docker-compose up -d --build
```

#### Table Migrations
The required tables to bootstrap the database are included in ToF's server repo in the `./sql` folder. The `Dockerfile-db` file adds
the SQL transactions into the init directory of the database, so the needed tables are created upon launch.

#### Build the DB's Docker Image

```bash
$ docker build -f $PWD/Dockerfile-db -t tof/mysql:5.7
```

## Run the Docker Stack

```
$ docker-compose up -d
```

To rebuild the docker images, run:

```bash
$ docker-compose up -d --build
```
