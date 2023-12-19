#!/bin/bash
set -e

# Start MongoDB in the background
mongod --fork --logpath /var/log/mongod.log

# Restore from dump
mongorestore /data/dump/

# Bring MongoDB back to the foreground
mongod --bind_ip_all
