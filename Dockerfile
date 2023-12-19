FROM mongo:latest
COPY Sera/ /data/dump/Sera
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
