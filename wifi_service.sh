#!/bin/bash

# Define the target location (latitude and longitude)
target_latitude=12.3456
target_longitude=78.9012

while true; do
    # Get current location
    current_latitude=$(termux-location -p network -r | jq -r '.latitude')
    current_longitude=$(termux-location -p network -r | jq -r '.longitude')

    # Check if within the target location
    if [[ $current_latitude == $target_latitude && $current_longitude == $target_longitude ]]; then
        # Check if Wi-Fi is currently off
        if [[ $(termux-wifi-connectioninfo | jq -r '.supplicant_state') == "DISCONNECTED" ]]; then
            # Turn on Wi-Fi
            termux-wifi-enable
            # Display notification
            termux-notification --id "wifi_status" --title "Wi-Fi Status" --content "Wi-Fi turned on"
        fi
    else
        # Check if Wi-Fi is currently on
        if [[ $(termux-wifi-connectioninfo | jq -r '.supplicant_state') == "COMPLETED" ]]; then
            # Turn off Wi-Fi
            termux-wifi-disable
            # Display notification
            termux-notification --id "wifi_status" --title "Wi-Fi Status" --content "Wi-Fi turned off"
        fi
    fi

    # Sleep for 5 minutes
    sleep 300
done
