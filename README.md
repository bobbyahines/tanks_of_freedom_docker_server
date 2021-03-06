# tanks_of_freedom_docker_server
Tanks of Freedom Server, running in Docker.

## About Tanks of Freedom Server
https://github.com/P1X-in/tanks-of-freedom-server#readme

## Changes Made to the Original Codebase
This build updates the requirements to most current versions of Flask, MySQL Client, etc.
In order to be compatible with these updates (as well as dockerization) two changes are made:

1. Foo.ext.Bar style deprecated for Foo_Bar style.
  A linux sed command is used to replace flask.ext.mysqldb with flask_mysqldb in the __init__.py file.
  
2. Docker host protocol 0.0.0.0 added to application launch.
  In `run.py`, I've changed `app.run(debug=True)` to `app.run(debug=True, host='0.0.0.0')` for a cleaner
  docker host interface.

# Getting Started

## The Easy Way

From within this directory:

```bash
$ docker-compose up -d --build
```

## The Manual Way

### TOF Server Stack is Code + DB

TOF server requires both its code and a mysql/mariadb database where it persists application data.

Respecting Docker's single process per container principle, the application and the database are run in separate containers.
As a result, they must be configured to "speak" to each other.

#### Pre-Flight Configurations: THE SERVER

##### config.py
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

##### Build the Server's Docker Image

From the repo directory, locally:
```
$ docker build -f $PWD/Dockerfile -t tof/server:latest .
```

#### Pre-Flight Configurations: THE DATABASE

##### Table Migrations
The required tables to bootstrap the database are included in ToF's server repo in the `./sql` folder. The `Dockerfile-db` file adds
the SQL transactions into the init directory of the database, so the needed tables are created upon launch.

##### Build the DB's Docker Image

```bash
$ docker build -f $PWD/Dockerfile-db -t tof/mysql:5.7
```

##### Run the Docker Stack

```
$ docker-compose up -d
```
