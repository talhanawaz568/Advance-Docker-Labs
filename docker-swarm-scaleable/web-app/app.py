from flask import Flask, request, jsonify
import redis
import os
import socket
import json
from datetime import datetime

app = Flask(__name__)

# Connect to Redis
redis_host = os.environ.get('REDIS_HOST', 'redis')
redis_port = int(os.environ.get('REDIS_PORT', 6379))
r = redis.Redis(host=redis_host, port=redis_port, decode_responses=True)

@app.route('/')
def home():
    hostname = socket.gethostname()
    try:
        # Increment visit counter
        visits = r.incr('visits')
        
        # Store visitor info
        visitor_info = {
            'timestamp': datetime.now().isoformat(),
            'hostname': hostname,
            'remote_addr': request.remote_addr
        }
        
        return jsonify({
            'message': 'Welcome to Docker Swarm Lab!',
            'container_hostname': hostname,
            'total_visits': visits,
            'visitor_info': visitor_info,
            'status': 'healthy'
        })
    except Exception as e:
        return jsonify({
            'message': 'Welcome to Docker Swarm Lab!',
            'container_hostname': hostname,
            'error': str(e),
            'status': 'redis_unavailable'
        }), 500

@app.route('/health')
def health():
    try:
        r.ping()
        return jsonify({'status': 'healthy', 'redis': 'connected'})
    except:
        return jsonify({'status': 'unhealthy', 'redis': 'disconnected'}), 500

@app.route('/info')
def info():
    hostname = socket.gethostname()
    return jsonify({
        'container_hostname': hostname,
        'app_version': '1.0.0',
        'python_version': os.sys.version,
        'environment': os.environ.get('ENVIRONMENT', 'development')
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
