#!/bin/bash

# Domain to check
DOMAIN="hetzner-lab.hcloud.example.com"

# Time window in days
DAYS=7

# Current time as Unix timestamp
NOW=$(date +%s)

# Fetch + count in einem Aufruf, alles inline
COUNT=$(curl -s "https://crt.sh/?q=${DOMAIN}&output=json" | \
jq --argjson now "$NOW" --argjson days "$DAYS" "
  [ .[] 
    | select(.issuer_name | contains(\"Let's Encrypt\"))
    | select(.not_before != null)
    | select(
        (.not_before | strptime(\"%Y-%m-%dT%H:%M:%S\") | mktime) > (\$now - (\$days * 86400))
      )
    | .serial_number
  ] | unique | length
")

echo "Unique Let's Encrypt certificates in the last ${DAYS} days for ${DOMAIN}: $COUNT"

