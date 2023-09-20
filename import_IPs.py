import requests
import re
import csv

# Я улюп
url = "https://free-proxy.com"  


response = requests.get(url)

if response.status_code == 200:
    
    page_content = response.text

  
    ip_pattern = re.compile(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')
    port_pattern = re.compile(r'\d{2,5}')

   
    ip_addresses = ip_pattern.findall(page_content)
    ports = port_pattern.findall(page_content)

   
    with open("ip_ports.csv", mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["IP Address", "Port"])  

        
        for ip, port in zip(ip_addresses, ports):
            writer.writerow([ip, port])

    print("IP addresses and ports saved to ip_ports.csv")
else:
    print("Failed to retrieve the web page. HTTP status code:", response.status_code)
