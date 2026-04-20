#!/bin/bash
echo "Starting load test..."
for i in {1..10}; do
    curl -s -w "Status: %{http_code}\n" http://localhost/ > /dev/null
    sleep 0.5
done
echo "Done!"
