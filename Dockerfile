# Dockerfile development version
FROM ruby:3.1.3 AS app-development

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    libpq-dev \
    postgresql-client \
    vim \
    nodejs \
    yarn \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Default directory
ENV INSTALL_PATH /usr/src/app
RUN mkdir -p $INSTALL_PATH

# Install gems
WORKDIR $INSTALL_PATH
COPY Gemfile* ./

RUN gem install rails bundler
RUN bundle install

RUN yarn install

COPY . .

# Start server
CMD bundle exec puma -w 0 -t 5 -p 3000