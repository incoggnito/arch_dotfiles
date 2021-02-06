#!/usr/bin/env bash

get_icon() {
    case $1 in
        # Icons for weather-icons
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="";;
        13n) icon="";;
        50d) icon="";;
        50n) icon="";;
        *) icon="";
    esac
    
    echo $icon
}

get_duration() {

    osname=$(uname -s)

    case $osname in
        *BSD) date -r "$1" -u +%H:%M;;
        *) date --date="@$1" -u +%H:%M;;
    esac

}

API="https://api.openweathermap.org/data/2.5"
UNITS="metric"
KEY="602893ea8eaf596b98de54acfc3bf299"
CITY="2867714"
SYMBOL="°"

CITY_PARAM="id=$CITY"
now=$(date +%s)

current=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")

current_icon=$(echo "$current" | jq -r ".weather[0].icon")
current_temp=$(echo "$current" | jq ".main.temp" | cut -d "." -f 1)
sun_rise=$(echo "$current" | jq ".sys.sunrise")
sun_set=$(echo "$current" | jq ".sys.sunset")

if [ "$sun_rise" -gt "$now" ]; then
    daytime=" $(get_duration "$((sun_rise-now))")"
elif [ "$sun_set" -gt "$now" ]; then
    daytime=" $(get_duration "$((sun_set-now))")"
else
    daytime=" $(get_duration "$((sun_rise-now))")"
fi

echo "$(get_icon "$current_icon") $current_temp$SYMBOL  $daytime"
