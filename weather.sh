#!/bin/bash
while getopts ":l:p:" o; do
    case "${o}" in
        l)
            location=${OPTARG}
            ;;
        h)
            p=${OPTARG}
            ;;
        *)
            ;;
    esac
done
base_url='http://api.apixu.com/v1/current.json?key=bef4b1337a6c4781826215259181511'
full_url=$base_url+'&q='+$location
weatherJson="$(curl $full_url | jq '.')"
locationdata="$(echo $weatherJson | jq '.location.name')"
echo "Showing weather for ${locationdata}"
