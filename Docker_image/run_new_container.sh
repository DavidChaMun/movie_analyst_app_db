#!/bin/bash
cd $(dirname $0)
helpFunction()
{
   echo ""
   echo "Usage: $0 -n container_name -p root_password "
   echo -e "\t-n Name of the database container to be created"
   echo -e "\t-p Root password for the running container"
   exit 1 # Exit script after printing help
}

while getopts "n:p:" opt
do
   case "$opt" in
      n ) container_name="$OPTARG" ;;
      p ) root_password="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$container_name" ] || [ -z "$root_password" ] 
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct

# Read name of image and version from buffer
image_name=`sed -n -e '1 s/image_name=// p' ./Buffers/buffer.txt`
version_tag=`sed -n -e '2 s/version_tag=// p' ./Buffers/buffer.txt`


docker run --name $container_name -e MYSQL_ROOT_PASSWORD=$root_password -d $image_name:$version_tag
docker exec $container_name '/init.sh'

if [ $? -ne 0 ]; then
    echo "Initializations failed, aborting"
    docker stop $container_name
    docker rm $container_name
else
    temp=$container_name
    host_dir=$(docker exec -it $temp bash -c 'IP=$(hostname -i); echo $IP')
    host_dir=$(echo $host_dir | sed -e 's/\n//g')
    host_dir=$(echo $host_dir | sed -e 's/\r//g')
    sed -i "$ a$container_name:$host_dir:3306" ./Buffers/buffer.txt
    echo "$container_name its now listening on $host_dir:3306"
fi