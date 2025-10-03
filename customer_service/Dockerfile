FROM ruby:3.2

WORKDIR /app

COPY . /app

RUN gem install bundler && bundle install

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3001"]
