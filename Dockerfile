FROM ruby:3.0.0

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client yarn

RUN mkdir /quitcost
WORKDIR /quitcost
COPY Gemfile /quitcost/Gemfile
COPY Gemfile.lock /quitcost/Gemfile.lock

RUN gem install bundler -v '2.2.31'
RUN bundle install

COPY . /quitcost
EXPOSE 3000
