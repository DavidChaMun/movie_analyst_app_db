docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi movie_analyst_db:0.02