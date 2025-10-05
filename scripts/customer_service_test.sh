#!/bin/bash
set -e

echo "🚀 Test customer service"

docker-compose exec customer_service bundle exec rails test