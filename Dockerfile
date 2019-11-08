FROM ruby

RUN apt-get update -qq && apt-get install -y build-essential

ENV HOME /emarsys_test
RUN mkdir $HOME
WORKDIR $HOME

ADD Gemfile* $HOME/
RUN bundle install

ADD . $HOME

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]