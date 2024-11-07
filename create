#!/bin/bash

# Usage: ./create --name SUBDOMAIN [--domain DOMAINNAME] [--type RECORDTYPE]

# Create a new subdomain with an A record, pointing to your IP current IP address
# New subdomain is added to a txt file to allow the updater to work correctly
# API documentation here: https://porkbun.com/api/json/v3/documentation

# Looks for apikeys.txt file in current directory and sources it.
if [ ! -f apikeys.txt ]; then
	echo "Error: apikeys.txt file not found!" 
	exit 1 
fi 

source apikeys.txt


# Retrieve current IPv4 address
myip=$(curl -s ipv4.icanhazip.com) 

# Default values. Populating these will allow you to run command without arguments
name=""
type="A"
domain="example.com"
output_file="domains.txt" # File to append the information


# Parse named arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      name="$2"
      shift 2
      ;;
    --type)
      type="$2"
      shift 2
      ;;
    --domain)
      domain="$2"
      shift 2
      ;;
    *)
      echo "Unknown parameter: $1"
      echo "Usage: $0 --name <name> [--type <type>] [--domain <domain>]"
      exit 1
      ;;
  esac
done

# Check if all required arguments are provided
if [ -z "$name" ] || [ -z "$type" ] || [ -z "$domain" ]; then
  echo "All parameters --name, --type, and --domain are required."
  echo "Usage: $0 --name <name> [--type <type>] [--domain <domain>]"
  exit 1
fi


# Make the API request
curl --header "Content-Type: application/json" \
  --request POST \
  --data "{ 
    \"apikey\" : \"$apikey\",
    \"secretapikey\" : \"$secretapikey\",
    \"name\" : \"$name\",
    \"type\" : \"$type\",
    \"content\" : \"$myip\",
    \"ttl\" : \"600\"
  }" \
  https://porkbun.com/api/json/v3/dns/create/"$domain"
echo

# update the domain list with the new subdomain
echo "$name.$domain" >> "$output_file"
