#!/bin/bash
loc=1
update=0
updatetime=300
tmp="./tmp/weather.json"
location="Poznan"
key=${APIXUKEY:-'http://api.apixu.com/v1/current.json?key=bef4b1337a6c4781826215259181511'}
while getopts ":l:fu" o
do	case "${o}" in
	l)	location="$OPTARG";;
	f)	loc=2;;
  u)  update=1;;
	esac
done
location="$(echo "\"$location\"" | awk '{print toupper($1)}')"
function updateData()
{
	curl --create-dirs -o $tmp $full_url
}
function getData()
{
	if [ -f $tmp ]
	then
		currentDate="$(date +%s)"
		tmpModTime="$(date -r $tmp +%s)"
		modTime=$((currentDate-tmpModTime))
		tmpLoc="$(cat $tmp | jq '.location.name')"
		tmpLoc="$(echo $tmpLoc | awk '{print toupper($1)}')"
		if [[ "$location" != "$tmpLoc" ]]
		then
			modTime=$(($updatetime+1))
		fi
	else
			modTime=$(($updatetime+1))
	fi
	if [[ $modTime -gt $updatetime ]]
	then
		updateData
	fi
}
function displayData()
{
  weatherJson="$(cat $tmp | jq '.')"
  locationData="$(echo $weatherJson | jq '.location.name')"
  if [[ "$locationData" = "null" ]]
  then
    echo "Unknown location"
  else
    clear
		ascii_art
    weatherData="$(echo $weatherJson | jq '.current.condition.text')"
    if [ $loc -eq 1 ]
    then
      tempData="$(echo $weatherJson | jq '.current.temp_c')C"
      windData="$(echo $weatherJson | jq '.current.wind_kph')""kph"
    else
      tempData="$(echo $weatherJson | jq '.current.temp_f')F"
      windData="$(echo $weatherJson | jq '.current.wind_mph')""mph"
    fi
		echo "=============================="
    echo "Showing weather for ${locationData}"
    echo "Weather today is ${weatherData}"
    echo "Temperature ${tempData}"
    echo "Wind blows ${windData}"
		echo "=============================="
		a=$((updatetime/60))
		echo "Updating every $a minutes"
  fi
  if [[ $1 > 0 ]]
  then
    sleep $1
  fi
}
function ascii_art(){
echo "██╗    ██╗███████╗ █████╗ ████████╗██╗  ██╗███████╗██████╗     ";
echo "██║    ██║██╔════╝██╔══██╗╚══██╔══╝██║  ██║██╔════╝██╔══██╗    ";
echo "██║ █╗ ██║█████╗  ███████║   ██║   ███████║█████╗  ██████╔╝    ";
echo "██║███╗██║██╔══╝  ██╔══██║   ██║   ██╔══██║██╔══╝  ██╔══██╗    ";
echo "╚███╔███╔╝███████╗██║  ██║   ██║   ██║  ██║███████╗██║  ██║    ";
echo " ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ";
echo "                                                               ";
}
	base_url=$key
	full_url=$base_url+'&q='+$location
if [ $update -eq 1 ]
then
  while [ $update -eq 1 ]
  do
		getData
    displayData $updatetime
  done
else
	getData
  displayData
fi
