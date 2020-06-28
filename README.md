# tanks_of_freedom_docker_server
Tanks of Freedom Server, running in Docker.

## About Tanks of Freedom Server
https://github.com/P1X-in/tanks-of-freedom-server#readme


## Build the Docker Image

```
$ docker-compose up -d --build
```

```
$ docker build -f Dockerfile -t tof/server:latest .
```

## Run the Docker Image

```
$ docker-compose up -d
```

```
$ docker run -it --rm --name tof_server -p "80:5000" -d tof/server:latest
```
