docker build -t ramp-app-db . 
docker run --name my_db0 -e MYSQL_ROOT_PASSWORD=sherlock -d ramp-app-db
docker exec my_db0 '/init.sh' 