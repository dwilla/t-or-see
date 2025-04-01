# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t eventbrite_clone .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name eventbrite_clone eventbrite_clone

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 libffi-dev node-gyp python-is-python3 sudo redis-server && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Create rails user and group
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Configure sudo for rails user
RUN echo "rails ALL=(ALL) NOPASSWD: /bin/mkdir, /bin/chown, /bin/chmod, /etc/init.d/redis-server" >> /etc/sudoers.d/rails && \
    chmod 0440 /etc/sudoers.d/rails

# Create and set permissions for /data directory
RUN mkdir -p /data && \
    chown -R rails:rails /data && \
    chmod -R 777 /data

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Set build environment to prevent environment variable access during build
ENV RAILS_ENV=build

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Reset RAILS_ENV for the final stage
ENV RAILS_ENV=production

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Set permissions for runtime files
RUN chown -R rails:rails db log storage tmp && \
    chmod +x /rails/bin/deploy && \
    mkdir -p /data && \
    chown -R rails:rails /data && \
    chmod -R 777 /data

USER 1000:1000

# Start server via Puma directly
EXPOSE 8080

# Run deploy script and start Puma
CMD ["/bin/bash", "-c", "/rails/bin/deploy && bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:8080"]
