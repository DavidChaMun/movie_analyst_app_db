#!/bin/bash
cd $(dirname $0)
helpFunction()
{
    echo ""
    echo "Usage: $0 -n image name -v version tag -u application_user -s application_password"
    echo -e "\t-n The name of the image to be built"
    echo -e "\t-t The version to be tagged with"
    echo -e "\t-u Read only application username"
    echo -e "\t-s Read only applcation password"
    exit 1 # Exit script after printing help
}

while getopts "n:t:u:s:" opt
do
   case "$opt" in
        n ) image_name="$OPTARG" ;;
        t ) version_tag="$OPTARG" ;;
        u ) ru_username="$OPTARG" ;;
        s ) ru_password="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$image_name" ] || [ -z "$version_tag" ] || [ -z "$ru_username" ] || [ -z "$ru_password" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct

#Preparing db template
sed -i "2 s/.*.*/CREATE USER '"$ru_username"'@'%' IDENTIFIED BY '"$ru_username"';/" db_start.sql
sed -i "3 s/.*.*/GRANT SELECT ON movie_db.* TO '"$ru_username"';/" db_start.sql


# Build image with parameters provided
docker build -t $image_name:$version_tag .
echo "Docker image built"

source ./Buffers/clean.sh
#Write parameters to buffer file
sed -i "1c\image_name=$image_name" ./Buffers/buffer.txt
sed -i "2c\version_tag=$version_tag" ./Buffers/buffer.txt
echo "buffer updated"