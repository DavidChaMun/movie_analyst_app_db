#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -n name -b parameterB -c parameterC"
   echo -e "\t-n name of the database to be launched"
   echo -e "\t-b Description of what is parameterB"
   echo -e "\t-c Description of what is parameterC"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:" opt
do
   case "$opt" in
      a ) parameterA="$OPTARG" ;;
      b ) parameterB="$OPTARG" ;;
      c ) parameterC="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ] || [ -z "$parameterB" ] || [ -z "$parameterC" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$parameterA"
echo "$parameterB"
echo "$parameterC"

docker build -t ramp-app-db . 
docker run --name my_db0 -e MYSQL_ROOT_PASSWORD=sherlock -d ramp-app-db
docker exec my_db0 '/init.sh' 