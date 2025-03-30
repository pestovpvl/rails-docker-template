FROM ruby:3.3-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips postgresql-client lsof libyaml-dev libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY . .

RUN gem install bundler && bundle install

EXPOSE {{PORT}}

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "{{PORT}}"]