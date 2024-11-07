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

# Loop through each domain in domains.txt
while IFS= read -r domain || [[ -n "$domain" ]]; do
    # Skip empty lines or lines that start with '#'
    [[ -z "$domain" || "$domain" =~ ^# ]] && continue

    subdomain="${domain%%.*}"  # Extract the subdomain part (e.g, www.)
    domain_name="${domain#*.}"  # Extract the domain name (e.g., example.com)

    echo "Checking current IP for $subdomain.$domain_name on Porkbun..."

    # Retrieve the current IP from Porkbun DNS record
    response=$(curl --silent --header "Content-Type: application/json" \
        --request POST \
        --data "{
            \"apikey\" : \"$apikey\",
            \"secretapikey\" : \"$secretapikey\"
        }" \
        "https://api.porkbun.com/api/json/v3/dns/retrieve/$domain_name")

    # Verify if the response contains records data
    if [[ -z "$response" ]] || [[ "$(echo "$response" | jq -r '.status')" != "SUCCESS" ]]; then
        echo "Error: Failed to retrieve DNS records for $domain_name. Skipping..."
        echo
        continue
    fi

    # Extract the current IP for the specified subdomain and type A record from the response
    current_dns_ip=$(echo "$response" | jq -r ".records[] | select(.name==\"$subdomain.$domain_name\" and .type==\"A\") | .content")

    # Check if the current DNS IP was found
    if [[ -z "$current_dns_ip" || "$current_dns_ip" == "null" ]]; then
        echo "Error: No A record found for $subdomain.$domain_name. Skipping..."
        echo
        continue
    fi

    # Debug output to confirm the IPs being compared
    echo "Retrieved IP for $subdomain.$domain_name: $current_dns_ip"

    # Step 1: Compare the current DNS IP and device IP
    if [[ "$current_dns_ip" == "$myip" ]]; then
        echo "IP for $subdomain.$domain_name is already up-to-date ($current_dns_ip). Skipping update."
        echo
    else
        echo "Updating $subdomain.$domain_name A record to $myip"

        # Step 2: Update the DNS record with the new IP
        update_response=$(curl --silent --header "Content-Type: application/json" \
            --request POST \
            --data "{
                \"apikey\" : \"$apikey\",
                \"secretapikey\" : \"$secretapikey\",
                \"content\" : \"$myip\",
                \"ttl\" : \"600\"
            }" \
            "https://api.porkbun.com/api/json/v3/dns/editByNameType/$domain_name/A/$subdomain")

        # Step 3: Check if the update was successful
        update_status=$(echo "$update_response" | jq -r '.status')
        if [[ "$update_status" == "SUCCESS" ]]; then
            echo "Successfully updated $subdomain.$domain_name to $myip"
            echo
        else
            echo "Error: Failed to update $subdomain.$domain_name. Response: $update_response"
            echo
        fi
    fi
done < domains.txt
