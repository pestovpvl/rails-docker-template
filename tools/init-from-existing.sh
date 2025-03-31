#!/bin/bash

# Usage: ./tools/init-from-existing.sh /path/to/rails-app myapp 3201

set -e

SOURCE_PATH=$1
APP_NAME=$2
PORT=$3

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/.."
TARGET_DIR="/var/www/$APP_NAME"

if [ -z "$SOURCE_PATH" ] || [ -z "$APP_NAME" ] || [ -z "$PORT" ]; then
  echo "Usage: $0 /path/to/rails-app <app_name> <port>"
  exit 1
fi

echo "📦 Preparing existing Rails app '$APP_NAME' for Docker on port $PORT..."

mkdir -p "$(dirname "$TARGET_DIR")"
cp -r "$SOURCE_PATH" "$TARGET_DIR"

# Copy template files
cp "$TEMPLATE_DIR"/Dockerfile "$TEMPLATE_DIR"/Makefile "$TEMPLATE_DIR"/.env.example "$TARGET_DIR"
[ -f "$TEMPLATE_DIR/init-new-project.sh" ] && cp "$TEMPLATE_DIR/init-new-project.sh" "$TARGET_DIR"

cp "$TEMPLATE_DIR"/docker-compose.yml "$TEMPLATE_DIR"/docker-compose.override.yml "$TEMPLATE_DIR"/docker-compose.prod.yml "$TARGET_DIR"

mkdir -p "$TARGET_DIR/bin"
cp "$TEMPLATE_DIR/bin/docker-entrypoint" "$TARGET_DIR/bin/"
chmod +x "$TARGET_DIR/bin/docker-entrypoint"

cd "$TARGET_DIR"

# Detect OS for sed
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED="sed -i ''"
else
  SED="sed -i"
fi

# Replace placeholders
grep -rl '{{APP_NAME}}' . | xargs $SED "s/{{APP_NAME}}/${APP_NAME}/g"
grep -rl '{{PORT}}' . | xargs $SED "s/{{PORT}}/${PORT}/g"

echo "✅ Project '$APP_NAME' is ready in: $TARGET_DIR"
echo "➡️  Next steps:"
echo "   cd $TARGET_DIR"
echo "   make up"