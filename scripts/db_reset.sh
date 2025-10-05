#!/bin/bash
set -e

echo "🚀 Reset de microservicios..."

# Reset base de datos Order Service
echo "📦 Order Service: aplicando migraciones..."
docker-compose run --rm order_service bundle exec rails db:drop db:create db:migrate db:seed

# Reset base de datos Customer Service
echo "📦 Customer Service: aplicando migraciones..."
docker-compose run --rm customer_service bundle exec rails db:drop db:create db:migrate db:seed

echo "✅ ¡Reset bases de datos listo!"
