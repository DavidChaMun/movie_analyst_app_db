#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -n image name -v version tag"
   echo -e "\t-n The name of the image to be built"
   echo -e "\t-t The version to be tagged with"
   exit 1 # Exit script after printing help
}

while getopts "n:t:" opt
do
   case "$opt" in
      n ) image_name="$OPTARG" ;;
      t ) version_tag="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$image_name" ] || [ -z "$version_tag" ] 
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct

# Build image with parameters provided
docker build -t $image_name:$version_tag .
echo "Docker image built"

#Write parameters to buffer file
sed -i "1c\image_name=$image_name" buffer.txt
sed -i "2c\version_tag=$version_tag" buffer.txt 
echo "buffer updated"