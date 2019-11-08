## Developer homework for Emarsys✨(2019)

#### Description:
https://github.com/noslopy/emarsys_test/files/3819796/Developer.homework._.2019.pdf

#### Solution:

* language: ruby 💎
* framework: sinatra 👨‍🎤
* persistent storage: postgreSQL 🗃️

So in this scenrio we have a separate service - a sinatra microservice - that is an API for Issues.
I dockerized the app to ease the configuration & setup.

run the following commands to set up env

```bash
docker-compose build
docker-compose run web rake db:create
docker-compose run web rake db:migrate
docker-compose run web rake db:migrate RACK_ENV=test
docker-compose run web ruby test/endpoint/issues_test.rb
```
