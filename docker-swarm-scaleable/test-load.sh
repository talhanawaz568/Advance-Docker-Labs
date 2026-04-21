#!/bin/bash

echo "Testing load distribution across replicas..."
echo "Making 20 requests to see different container hostnames:"
echo

for i in {1..20}; do
    echo "Request $i:"
    curl -s http://localhost/ | grep -o '"container_hostname":"[^"]*"' | cut -d'"' -f4
    sleep 0.5
done

echo
echo "Testing completed. You should see requests distributed across different containers."
