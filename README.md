# baoDNS
Update Domains and DNS settings directly via Porkbuns API

Documentaion for the Porkbun API can be found [here](https://porkbun.com/api/json/v3/documentation).

These scripts may be useful if you need to create or update subdomains to use your current IP address. 
Ideal if you're running a reverse proxy at home for your home lab.
NOTE this won't work for your primary domain, only subdomains

Download all files and place them in their own folder (such as dns) for easy access. make sure to chmod +x the .sh files to allow execution and chmod 600 the apikeys.txt to ensure no other users can access your API keys.

## apikeys.txt
Copy and paste your API keys from Porkbun in here. Keys can be generated [here](https://porkbun.com/account/api).

## domains.txt
A list of each domain name on a new line

## create.sh
Usage:
./create.sh --name SUBDOMAIN --domain DOMAINNAME --type RECORD

e.g. ./create.sh --name geek --domain example.com --type A
Record types supported are A, MX, CNAME, ALIAS, TXT, NS, AAAA, SRV, TLSA, CAA, HTTPS, SVCB

This will create a new subdomain and record, updating it with your current IP address and add it to the domains.txt file.

## update.sh
Usage:
./update.sh
Iterates through the domains.txt file and checks whether the current public IP matches the DNS record. If it does, it skips the update, else it will update the IP.

## To Do
- Possibly seperate the IP lookup to its own file.
- Tidy up all the sloppy hacky messy code
- allow IP to be passed as an optional parameter for both scripts, defaulting to current IP otherwise.
- maybe set arguments for user to choose whether to bulk update all subdomains or pass argument for single subdomain.
