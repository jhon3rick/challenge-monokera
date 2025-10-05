#!/bin/bash
set -e

echo "🚀 Inicializar consumidor de RabbitMQ..."

docker-compose run --rm customer_service bundle exec rails rabbit:consume