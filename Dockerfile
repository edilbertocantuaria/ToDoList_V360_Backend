FROM ruby:3.3

RUN apt-get update -y && apt-get install -y \
  nodejs \
  yarn \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

ENTRYPOINT ["sh", "-c", "bundle exec rails db:create db:migrate db:seed && rails server -b 0.0.0.0"]

CMD ["rails", "server", "-b", "0.0.0.0"]