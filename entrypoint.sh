#!/bin/bash
set -e

# Configuration Variables
MONGO_URI="mongodb+srv://sera-user:4048WWDfkhORZ0Qo@sera.kloehqy.mongodb.net"
MONGO_DUMP_PATH="/data/dump"
MONGO_LOG_PATH="/var/log/mongod.log"
MONGO_BIND_IP="0.0.0.0"
REPLICA_SET_NAME="rs0"
MONGO_PORT=27017
DATABASE_NAME="nginx"

# Function to wait for MongoDB to become available
wait_for_mongo() {
    until mongosh --eval "print('MongoDB is up')" >/dev/null 2>&1; do
        echo "Waiting for MongoDB to start..."
        sleep 2
    done
}

echo "Starting MongoDB in the background..."
mongod --fork --logpath "$MONGO_LOG_PATH" --bind_ip "$MONGO_BIND_IP" --replSet "$REPLICA_SET_NAME" --port $MONGO_PORT

# Wait for MongoDB to be available
wait_for_mongo

# Initialize the replica set
echo "Initializing the replica set..."
mongosh --eval "rs.initiate()"

# Wait for the replica set to be fully initialized
until mongosh --eval "rs.status()" | grep -q "stateStr"; do
    echo "Waiting for replica set to initialize..."
    sleep 2
done

# Dump data from the external MongoDB instance
echo "Cloning data from the external MongoDB instance..."
mongodump --uri="$MONGO_URI" --out="$MONGO_DUMP_PATH"

# Restore the dumped data to the local MongoDB instance
echo "Restoring the cloned data to the local MongoDB instance..."
mongorestore --drop --dir="$MONGO_DUMP_PATH"

# Indicate completion
echo "MongoDB setup script completed."