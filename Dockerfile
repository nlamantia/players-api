FROM ruby:3.2-alpine

RUN apk add --update --no-cache \
    build-base \
    git \
    postgresql-dev \
    postgresql-client \
    tzdata

COPY Gemfile Gemfile.lock /app/

WORKDIR /app/

RUN bundle install

COPY . /app/

EXPOSE 3000

CMD ["./script/start"]
