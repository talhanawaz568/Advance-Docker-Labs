#!/bin/bash

echo "Starting service monitoring..."
echo "Press Ctrl+C to stop monitoring"
echo

while true; do
    clear
    echo "=== Docker Swarm Service Status ==="
    echo "Timestamp: $(date)"
    echo
    
    echo "--- Service List ---"
    docker service ls
    echo
    
    echo "--- Web App Service Details ---"
    docker service ps webapp-stack_web-app --format "table {{.Name}}\t{{.Node}}\t{{.CurrentState}}\t{{.Error}}"
    echo
    
    echo "--- Nginx Service Details ---"
    docker service ps webapp-stack_nginx --format "table {{.Name}}\t{{.Node}}\t{{.CurrentState}}\t{{.Error}}"
    echo
    
    echo "--- Application Health Check ---"
    curl -s http://localhost/health | head -1 || echo "Health check failed"
    echo
    
    sleep 5
done
