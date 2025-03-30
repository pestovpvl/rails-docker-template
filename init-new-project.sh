#!/bin/bash

# Usage: ./init-new-project.sh myapp 3201

set -e

APP_NAME=$1
PORT=$2
TEMPLATE_DIR="rails-docker-template"
TARGET_DIR="/var/www/$APP_NAME"

if [ -z "$APP_NAME" ] || [ -z "$PORT" ]; then
  echo "Usage: $0 <app_name> <port>"
  exit 1
fi

echo "🚀 Creating new app: $APP_NAME on port $PORT"

# Copy template
cp -r "$TEMPLATE_DIR" "$TARGET_DIR"
cd "$TARGET_DIR"

# Replace placeholders
grep -rl '{{APP_NAME}}' . | xargs sed -i "s/{{APP_NAME}}/${APP_NAME}/g"
grep -rl '{{PORT}}' . | xargs sed -i "s/{{PORT}}/${PORT}/g"

# Create new Rails app inside the copied folder
docker compose run --rm app rails new . --force --skip-bundle --skip-active-storage
docker compose build

echo "✅ App '$APP_NAME' is ready at port $PORT"
echo "➡️  Next: cd $TARGET_DIR && make up"