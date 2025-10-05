#!/bin/bash
set -e

echo "🚀 Test order service"

docker-compose exec order_service bundle exec rails test