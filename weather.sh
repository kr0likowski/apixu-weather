#!/bin/bash
loc=1
update=0
time=300
location="Poznan"
key=${APIXUKEY:-'http://api.apixu.com/v1/current.json?key=bef4b1337a6c4781826215259181511'}
while getopts ":l:fu" o
do	case "${o}" in
	l)	location="$OPTARG";;
	f)	loc=2;;
  u)  update=1;;
	esac
done
function getData()
{
  weatherJson="$(curl $full_url | jq '.')"
  locationData="$(echo $weatherJson | jq '.location.name')"
  if [[ "$locationData" = "null" ]]
  then
    echo "Unknown location"
  else
    clear
    weatherData="$(echo $weatherJson | jq '.current.condition.text')"
    if [ $loc -eq 1 ]
    then
      tempData="$(echo $weatherJson | jq '.current.temp_c')"
      windData="$(echo $weatherJson | jq '.current.wind_kph')""kph"
    else
      tempData="$(echo $weatherJson | jq '.current.temp_f')"
      windData="$(echo $weatherJson | jq '.current.wind_mph')""mph"
    fi
		echo "=============================="
    echo "Showing weather for ${locationData}"
    echo "Weather today is ${weatherData}"
    echo "Temperature ${tempData}"
    echo "Wind blows ${windData}"
		echo "=============================="
  fi
  if [[ $1 > 0 ]]
  then
    sleep $1
  fi
}
	base_url=$key
	full_url=$base_url+'&q='+$location
if [ $update -eq 1 ]
then
  while [ $update -eq 1 ]
  do
    getData $time
  done
else
  getData
fi
