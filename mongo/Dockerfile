FROM mongo:latest
COPY ./mongo-dump /dump
COPY import.sh /import.sh
RUN chmod +x /import.sh
CMD ["/import.sh"]