#!/bin/bash
set -e

# Configuration Variables
MONGO_URI="mongodb+srv://sera-user:4048WWDfkhORZ0Qo@sera.kloehqy.mongodb.net"
MONGO_DUMP_PATH="/data/dump"
MONGO_LOG_PATH="/var/log/mongod.log"
MONGO_BIND_IP="0.0.0.0"

# Function to wait for MongoDB to become available
wait_for_mongo() {
    until mongo --eval "print('MongoDB is up')" >/dev/null 2>&1; do
        echo "Waiting for MongoDB to start..."
        sleep 2
    done
}

# Start local MongoDB in the background
echo "Starting MongoDB in the background..."
mongod --fork --logpath "$MONGO_LOG_PATH" --bind_ip "$MONGO_BIND_IP"

# Wait for MongoDB to be available
wait_for_mongo

# Dump data from the external MongoDB instance
echo "Cloning data from the external MongoDB instance..."
mongodump --uri="$MONGO_URI" --out="$MONGO_DUMP_PATH"

# Restore the dumped data to the local MongoDB instance
echo "Restoring the cloned data to the local MongoDB instance..."
mongorestore --drop --dir="$MONGO_DUMP_PATH"

# Stop the local MongoDB server
echo "Shutting down the background MongoDB..."
mongod --shutdown

# Start MongoDB in the foreground
echo "Starting MongoDB in the foreground..."
exec mongod --replSet rs0 --fork --logpath "$MONGO_LOG_PATH" --bind_ip "$MONGO_BIND_IP"

# Initiate the replica set
mongo --port 27017 <<EOF
rs.initiate({
    _id: "rs0",
    members: [
        { _id: 0, host: "localhost:27017" }
    ]
});
EOF

# Check the status of the replica set
mongo --port 27017 <<EOF
rs.status();
EOF

echo "Replica set initiated and status checked."