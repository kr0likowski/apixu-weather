#!/bin/bash
loc=1
location="Poznan"
while getopts l:f o
do	case "$o" in
	l)	location="$OPTARG";;
	f)	loc=2;;
	esac
done

base_url='http://api.apixu.com/v1/current.json?key=bef4b1337a6c4781826215259181511'
full_url=$base_url+'&q='+$location
weatherJson="$(curl $full_url | jq '.')"
locationData="$(echo $weatherJson | jq '.location.name')"
weatherData="$(echo $weatherJson | jq '.current.condition.text')"
if [ $loc -eq 1 ]
then
  tempData="$(echo $weatherJson | jq '.current.temp_c')"
  windData="$(echo $weatherJson | jq '.current.wind_kph')""kph"
else
  tempData="$(echo $weatherJson | jq '.current.temp_f')"
  windData="$(echo $weatherJson | jq '.current.wind_mph')""mph"
fi
echo "Showing weather for ${locationData}"
echo "Weather today is ${weatherData}"
echo "Temperature ${tempData}"
echo "Wind blows ${windData}"
