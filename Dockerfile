FROM ruby:3.0.6-buster

RUN apt-get update -qq && apt-get install -y build-essential nodejs default-mysql-client libmariadb-dev-compat
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js 14
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

RUN mkdir /src
WORKDIR /src

COPY Gemfile /src/Gemfile
COPY Gemfile.lock /src/Gemfile.lock

RUN bundle install

COPY . /src
