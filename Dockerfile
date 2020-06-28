FROM python:3
LABEL maintainer="Bobby Hines <bobbyahines@gmail.com>"
LABEL image="tof/server:latest"

# Refresh package repositories and update base image
RUN apt update && apt dist-upgrade -y
# Install utilities
RUN apt update && apt install git nano wget -y
# Update Pip
RUN pip install --upgrade pip

WORKDIR /tmp
# Install server application dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Clone in the server source code, and move it to the srv dir.
RUN git clone https://github.com/P1X-in/tanks-of-freedom-server.git
RUN rm -Rf /srv && mv tanks-of-freedom-server/ /srv

# Set working directory
WORKDIR /srv

# Add a null IP to the flask server for the docker host
RUN sed -ri -e 's!debug=True!debug=True, host="0.0.0.0"!g' ./run.py

# Correct the deprecated .ext flask call
RUN sed -ri -e 's!flask.ext.mysqldb!flask_mysqldb!g' ./tof_server/__init__.py

# Create the configuration file for database access, etc.
COPY config.py /srv/tof_server/config.py

# Set the volume, and web port
VOLUME /srv
EXPOSE 5000

# Launch flask app server on docker up
CMD ["python3", "run.py"]
