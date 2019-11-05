#############################
# stage 1 - instal gems
#############################
FROM ruby:2.6.5 as bundle_install

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# install dependencies
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    nodejs yarn build-essential libpq-dev imagemagick git-all nano

# install libs
ENV BUNDLE_PATH /gems
COPY Gemfile Gemfile.lock package.json yarn.lock $INSTALL_PATH/
RUN bundle install --deployment --without development test -j4 --retry 3
RUN yarn install


#############################
# stage 2 - precompile assets
#############################
FROM ruby:2.6.5 as precompile_assets

ENV INSTALL_PATH /app
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

# copy gems from former build stage
ENV BUNDLE_PATH /gems
COPY --from=bundle_install /gems /gems
COPY --from=bundle_install $INSTALL_PATH $INSTALL_PATH

# precompile assets
ENV RAILS_ENV production
RUN bundle exec rake assets:precompile

# remove folders not needed in resulting image
RUN rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec


#############################
# stage 3 - app
#############################
FROM ruby:2.6.5

ENV INSTALL_PATH /app
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

# copy gems from former build stage
ENV BUNDLE_PATH /gems
COPY --from=bundle_install /gems /gems
COPY --from=precompile_assets $INSTALL_PATH/public/assets $INSTALL_PATH/public/assets

# set env
ENV RAILS_ENV production

# add user
RUN addgroup -g 1000 -S app && adduser -u 1000 -S app -G app
RUN chown -R app:app $INSTALL_PATH
USER app

# expose puma port
EXPOSE 3000

# save timestamp of image building
RUN date -u > BUILD_TIME

# start up
ENTRYPOINT ['./entrypoint.sh']
