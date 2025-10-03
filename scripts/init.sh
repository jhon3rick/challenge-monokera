#!/bin/bash
set -e

echo "🚀 Configuración inicial de microservicios..."

# Asegurar que estamos en la carpeta raíz del proyecto
cd "$(dirname "$0")"

echo "⏳ Esperando a que Postgres esté listo..."
#until docker-compose exec -T db pg_isready -h db -U postgres; do
#  sleep 2
#done

# Migrar base de datos Order Service
echo "📦 Order Service: aplicando migraciones..."
docker-compose run --rm order_service bundle exec rails db:prepare

# Migrar base de datos Customer Service
echo "📦 Customer Service: aplicando migraciones..."
docker-compose run --rm customer_service bundle exec rails db:prepare

echo "✅ ¡Bases de datos listas y migraciones aplicadas!"