#!/bin/bash
set -e

echo "🚀 Configuración inicial de microservicios..."

# Migrar base de datos Order Service
echo "📦 Order Service: aplicando migraciones..."
docker-compose run --rm order_service bundle exec rails db:prepare

# Migrar base de datos Customer Service
echo "📦 Customer Service: aplicando migraciones..."
docker-compose run --rm customer_service bundle exec rails db:prepare

echo "✅ ¡Bases de datos listas y migraciones aplicadas!"
