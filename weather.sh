#!/bin/bash
base_url='http://api.apixu.com/v1/current.json?key=bef4b1337a6c4781826215259181511'
location='Poznan'
full_url=$base_url+'&q='+$location
weatherJson="$(curl $full_url | jq '.')"
echo "${weatherJson}"
