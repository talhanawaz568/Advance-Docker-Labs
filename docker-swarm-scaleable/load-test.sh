#!/bin/bash

echo "Starting load test..."
echo "This will make 100 concurrent requests to test fault tolerance"

# Function to make requests
make_requests() {
    local thread_id=$1
    local requests_per_thread=$2
    
    for ((i=1; i<=requests_per_thread; i++)); do
        response=$(curl -s -w "%{http_code}" http://localhost/ -o /dev/null)
        if [ "$response" != "200" ]; then
            echo "Thread $thread_id: Request $i failed with code $response"
        else
            echo "Thread $thread_id: Request $i successful"
        fi
        sleep 0.1
    done
}

# Start multiple background processes
for thread in {1..5}; do
    make_requests $thread 20 &
done

# Wait for all background jobs to complete
wait

echo "Load test completed"
