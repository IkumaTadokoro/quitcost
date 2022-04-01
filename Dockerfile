FROM ruby:3.0.3
ARG RAILS_ENV=development
ARG RAILS_SERVE_STATIC_FILES
ENV RAILS_ENV=$RAILS_ENV
ENV RAILS_SERVE_STATIC_FILES=$RAILS_SERVE_STATIC_FILES

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client yarn

RUN mkdir /quitcost
WORKDIR /quitcost
COPY Gemfile /quitcost/Gemfile
COPY Gemfile.lock /quitcost/Gemfile.lock

RUN gem install bundler -v '2.2.31'
RUN bundle install

COPY package.json /quitcost/package.json
COPY yarn.lock  /quitcost/yarn.lock
RUN yarn install

COPY . /quitcost
# Compile assets
RUN if [ "$RAILS_ENV" = "production" ]; then SECRET_KEY_BASE=$(rake secret) bundle exec rake assets:precompile; fi

EXPOSE 3000
