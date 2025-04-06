#!/bin/bash

# Usage: ./init-new-project.sh myapp 3201

set -e

APP_NAME=$1
PORT=$2
TEMPLATE_DIR="$(pwd)"
TARGET_DIR="/var/www/$APP_NAME"

if [ -z "$APP_NAME" ] || [ -z "$PORT" ]; then
  echo "Usage: $0 <app_name> <port>"
  exit 1
fi

echo "🚀 Creating new app: $APP_NAME on port $PORT"

# Copy template files to target directory, excluding .git and tmp dirs
rsync -av --progress "$TEMPLATE_DIR/" "$TARGET_DIR" --exclude .git --exclude tmp
cd "$TARGET_DIR"

# Replace placeholders in files
find . -type f \( -name "*.yml" -o -name "*.sh" -o -name "Dockerfile" -o -name "Makefile" \) -exec sed -i "" "s/{{APP_NAME}}/${APP_NAME}/g" {} +
find . -type f \( -name "*.yml" -o -name "*.sh" -o -name "Dockerfile" -o -name "Makefile" \) -exec sed -i "" "s/{{PORT}}/${PORT}/g" {} +

# Create Gemfile and necessary files for Rails
rm -f Gemfile Gemfile.lock
DOCKER_BUILDKIT=0 docker compose run --rm web bash -c "gem install rails && rails new . --force --skip-bundle --skip-active-storage"

# Ensure lockfile exists before build
touch Gemfile
touch Gemfile.lock

touch .dockerignore

# Disable BuildKit and force rebuild to avoid caching issues
DOCKER_BUILDKIT=0 docker compose build --no-cache

# Start containers
docker compose up -d

echo "✅ App '$APP_NAME' is ready at port $PORT"
echo "➡️  To get started: cd $TARGET_DIR"
