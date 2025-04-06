FROM ruby:3.3-slim

# Force rebuild marker
RUN echo "FORCE BUILD v1"

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    postgresql-client \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy all source files
COPY . .

EXPOSE 3000

# Start the Rails server
CMD ["bin/rails", "s", "-b", "0.0.0.0"]