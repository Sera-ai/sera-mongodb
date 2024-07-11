# Stage 1: Install MongoDB in a separate stage
FROM mongod:latest


# Create MongoDB data directory
RUN mkdir -p /data/db

# Set working directory for the Node app
WORKDIR /workspace

RUN mkdir /workspace/.logs

# Copy the application's source code
COPY . .

# Expose ports
EXPOSE 27017

RUN sed -i 's/\r$//' /workspace/entrypoint.sh
RUN chmod +x /workspace/entrypoint.sh

ENTRYPOINT ['/workspace/entrypoint.sh']
