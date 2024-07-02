# Stage 1: Install MongoDB in a separate stage
FROM debian:buster-slim as mongodb

# Add MongoDB to the sources list and install it
RUN apt-get update \
    && apt-get install -y gnupg wget \
    && wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add - \
    && echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list \
    && apt-get update \
    && apt-get install -y mongodb-org

# Install required dependencies and development packages
RUN apt-get update \
    && apt-get install -y curl xz-utils openssl git libcurl4 gettext software-properties-common moreutils build-essential 

# Create MongoDB data directory
RUN mkdir -p /data/db

# Set working directory for the Node app
WORKDIR /workspace

RUN mkdir /workspace/.logs


# Copy the application's source code
COPY . .

# Clean up the apt cache by removing /var/lib/apt/lists
RUN rm -rf /var/lib/apt/lists/*

# Environment variables for SSL certificate generation
ENV SSL_COUNTRY="US"
ENV SSL_STATE="Florida"
ENV SSL_LOCALITY="Tampa"
ENV SSL_ORG="Sera"
ENV SSL_COMMON_NAME="localhost"



# Expose ports
EXPOSE 27017

RUN sed -i 's/\r$//' ./sera-db-mongo/entrypoint.sh
RUN chmod +x ./sera-db-mongo/entrypoint.sh