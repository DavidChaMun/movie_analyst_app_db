FROM mariadb:10.1

COPY init.sh ..
COPY db_start.sql ..
RUN chmod +x init.sh

CMD ["mysqld"]
