FROM ruby:3.0.1-slim

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       default-libmysqlclient-dev \
                       default-mysql-client \
                       git \
   && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
COPY . /app

ENV APP_ROOT /app
WORKDIR $APP_ROOT

RUN gem install bundler
RUN bundle install

CMD ["sh", "docker-entrypoint.sh"]
