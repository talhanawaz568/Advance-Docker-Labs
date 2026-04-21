#!/bin/bash

echo "Testing network resilience..."

# Get container IDs
WEB_CONTAINERS=$(docker ps --filter "label=com.docker.swarm.service.name=webapp-stack_web-app" --format "{{.ID}}")
REDIS_CONTAINER=$(docker ps --filter "label=com.docker.swarm.service.name=webapp-stack_redis" --format "{{.ID}}")

echo "Web containers: $WEB_CONTAINERS"
echo "Redis container: $REDIS_CONTAINER"

# Test application behavior when Redis is unavailable
echo "Stopping Redis to simulate database failure..."
docker pause $REDIS_CONTAINER

# Test application response
echo "Testing application response without Redis:"
for i in {1..5}; do
    echo "Test $i:"
    curl -s http://localhost/ | grep -o '"status":"[^"]*"' || echo "Request failed"
    sleep 1
done

# Restore Redis
echo "Restoring Redis..."
docker unpause $REDIS_CONTAINER

# Wait for Redis to be ready
sleep 3

# Test recovery
echo "Testing application recovery:"
for i in {1..5}; do
    echo "Recovery test $i:"
    curl -s http://localhost/ | grep -o '"status":"[^"]*"' || echo "Request failed"
    sleep 1
done

echo "Network resilience test completed"
