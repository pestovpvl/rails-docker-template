#!/bin/bash

# Usage: ./tools/init-from-existing.sh /path/to/rails-app myapp 3201

set -e

SOURCE_PATH=$1
APP_NAME=$2
PORT=$3
TEMPLATE_DIR="$(dirname "$0")/.."
TARGET_DIR="/var/www/$APP_NAME"

if [ -z "$SOURCE_PATH" ] || [ -z "$APP_NAME" ] || [ -z "$PORT" ]; then
  echo "Usage: $0 /path/to/rails-app <app_name> <port>"
  exit 1
fi

echo "📦 Preparing existing Rails app '$APP_NAME' for Docker on port $PORT..."

# Copy project
cp -r "$SOURCE_PATH" "$TARGET_DIR"

# Add Docker template files
cp "$TEMPLATE_DIR"/Dockerfile "$TEMPLATE_DIR"/Makefile "$TEMPLATE_DIR"/.env.example "$TEMPLATE_DIR"/init-new-project.sh "$TARGET_DIR"
cp "$TEMPLATE_DIR"/docker-compose.yml "$TEMPLATE_DIR"/docker-compose.override.yml "$TEMPLATE_DIR"/docker-compose.prod.yml "$TARGET_DIR"
mkdir -p "$TARGET_DIR/bin"
cp "$TEMPLATE_DIR"/bin/docker-entrypoint "$TARGET_DIR"/bin/
chmod +x "$TARGET_DIR/bin/docker-entrypoint"

cd "$TARGET_DIR"

# Replace placeholders
grep -rl '{{APP_NAME}}' . | xargs sed -i "s/{{APP_NAME}}/${APP_NAME}/g"
grep -rl '{{PORT}}' . | xargs sed -i "s/{{PORT}}/${PORT}/g"

echo "✅ Project '$APP_NAME' is ready in: $TARGET_DIR"
echo "➡️  Next steps:"
echo "   cd $TARGET_DIR"
echo "   make up"