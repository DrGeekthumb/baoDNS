#!/bin/bash

# Load API keys from apikeys.txt
if [ ! -f apikeys.txt ]; then
    echo "Error: apikeys.txt file not found!"
    exit 1
fi

source apikeys.txt

# Check if domains.txt exists
if [ ! -f domains.txt ]; then
    echo "Error: domains.txt file not found!"
    exit 1
fi

# Retrieve the current public IP of the machine using the Porkbun API
echo "Retrieving the current device IP..."
myip=$(curl --silent --header "Content-Type: application/json" \
  --request POST \
  --data "{
    \"apikey\" : \"$apikey\",
    \"secretapikey\" : \"$secretapikey\"
  }" \
  https://api-ipv4.porkbun.com/api/json/v3/ping | jq -r '.yourIp')

if [ -z "$myip" ]; then
    echo "Error: Unable to retrieve the device's IP address."
    echo
    exit 1
fi

echo "Current device IP: $myip"
echo

# Loop through each domain and record type in domains.txt
while IFS=' ' read -r domain record_type || [[ -n "$domain" ]]; do
    # Skip empty lines or lines that start with '#'
    [[ -z "$domain" || "$domain" =~ ^# ]] && continue

    if [[ -z "$record_type" ]]; then
        echo "Error: No record type
