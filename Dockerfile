FROM mongo
COPY Sera/ /data/dump/Sera
CMD mongorestore /data/dump/
