FROM ruby:2.6.5

ENV RAILS_ENV production
ENV INSTALL_PATH /app
ENV BUNDLE_PATH /box

RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# install dependencies
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    nodejs yarn build-essential libpq-dev imagemagick git-all nano

# copy app
COPY . $INSTALL_PATH

# install libs
RUN gem install bundler:2.0.2
RUN bundle install --deployment --without development test -j4 --retry 3
RUN yarn install

# precompile assets
RUN bundle exec rake assets:precompile

# expose puma port
EXPOSE 3000
