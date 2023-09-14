#!/bin/bash

url="https://free-proxy-list.net/"  

page_content=$(curl -s "$url")

ip_regex="\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
port_regex="\b[0-9]{2,5}\b"

ip_addresses=$(echo "$page_content" | grep -E -o "$ip_regex" | awk '!a[$0]++')
ports=$(echo "$page_content" | grep -E -o "$port_regex" | awk '!a[$0]++')

csv_file="ip_ports.csv"
echo "IP Address,Port" > "$csv_file"

paste -d "," <(echo "$ip_addresses") <(echo "$ports") >> "$csv_file"

echo "IP addresses and ports saved to $csv_file"

