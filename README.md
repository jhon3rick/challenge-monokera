# Monokera - Prueba técnica (skeleton)
Este repositorio contiene un esqueleto para la prueba técnica descrita: dos servicios Rails (API-like) y orchestración con Docker Compose.

**Importante**: este ZIP contiene archivos de ejemplo y skeletons (controladores, servicios, migrations y tareas Rake). Para ejecutar una app Rails completa debes ejecutar `bundle install` y crear las apps Rails con `rails new ... --api` si prefieres generar el proyecto real. Los archivos incluidos muestran la implementación clave requerida por la prueba técnica.

## Contenido relevante
- `order_service/` - esqueleto de Order Service (API)
- `customer_service/` - esqueleto de Customer Service (API)
- `docker-compose.yml` - orquesta Postgres y RabbitMQ y ambos servicios
- `README.md` - este archivo

## Cómo usar (instrucciones resumidas)
1. Clona y descomprime este archivo.
2. Ajusta `.env` en cada servicio con las variables reales.
3. Construye las imágenes y levanta servicios:
   ```bash
   docker-compose build
   docker-compose up -d
   ```
4. En cada servicio ejecuta migraciones y seeds (una vez que tengas una app Rails completa):
   ```bash
   # ejemplo dentro del contenedor
   rails db:create db:migrate db:seed
   ```
5. Para consumir eventos desde `customer_service` hay una rake task `rabbit:consume`.

---
Si quieres, puedo ahora generar un repositorio completo con las apps Rails (`rails new ...`) dentro del zip — eso aumentará considerablemente el tamaño y tardaría más. Dime si prefieres el skeleton (este zip) o el proyecto Rails completo y lo creo inmediatamente.
