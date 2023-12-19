#!/bin/bash
set -e

# Start MongoDB in the background
mongod --fork --logpath /var/log/mongod.log --bind_ip_all

# Restore from dump
mongorestore /data/dump/

# Now, since MongoDB is already running in the background, 
# we don't need to start it again. Instead, we wait for the background MongoDB process to complete.
wait
