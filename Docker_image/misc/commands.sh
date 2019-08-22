#get image
docker pull mariadb:10.1

#build image
docker build -t ramp-app-db .

#create container
docker run --name my_db0 -e MYSQL_ROOT_PASSWORD=sherlock -d ramp-app-db
docker run --name malyst_apic01 -e DB_HOST=$(docker exec -it movie_db_c01 bash -c 'IP=$(hostname -i); echo $IP') -d movie_analyst_api
docker run --name malyst_uic01 -e BACK_HOST=$(docker exec -it malyst_apic01 bash -c 'IP=$(hostname -i); echo $IP') -d movie_analyst_ui

#copy file from host to docker
docker cp init.sh my_db0:/
docker cp db_start.sql my_db0:/

#give exec permission to init
docker exec my_db0 bash -c 'chmod +x init.sh' 

#exec init
docker exec my_db0 '/init.sh' 

# Get the ip of the running container
docker exec -it my_db0 bash -c 'IP=$(hostname -i); echo $IP'
docker exec -it movie_db_c01 bash -c 'IP=$(hostname -i); echo $IP'

# exec bash inside container
docker exec -it my_db0 bash

#connect remotely to db
mysql --protocol=tcp --host=$(docker exec -it my bash -c 'IP=$(hostname -i); echo $IP') --port=3306 --user=applicationuser -p
mysql --protocol=tcp --host=172.17.0.2 --port=3306 --user=applicationuser -p

#run a sql file in terminal
#the temp.cnf file must contain user and password
mysql --defaults-extra-file='/temp.cnf' < db_start.sql

#delete containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

#remove images
docker rmi ramp-app-db

#build container
docker build -t ramp-app-db .
