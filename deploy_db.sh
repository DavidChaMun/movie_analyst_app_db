#!/bin/bash
cd $(dirname $0)
helpFunction()
{
   echo ""
   echo "Usage: $0 -p Root password -u Application user's username -s Application user's password"
   echo -e "\t-p Description of what is root_password"
   echo -e "\t-u Description of what is app_username"
   echo -e "\t-s Description of what is app_password"
   exit 1 # Exit script after printing help
}

while getopts "p:u:s:" opt
do
   case "$opt" in
      p ) root_password="$OPTARG" ;;
      u ) app_username="$OPTARG" ;;
      s ) app_password="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$root_password" ] || [ -z "$app_username" ] || [ -z "$app_password" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
chmod +x /Docker_image/create_docker_image.sh 
chmod +x /Docker_image/run_new_container.sh

./Docker_image/create_docker_image.sh -n movie_analyst_db -t 0.02 -u $app_username -s $app_password
./Docker_image/run_new_container.sh -n movie_db_c01 -p $root_password 
echo "App can now query wity user $app_username"