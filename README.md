## Developer homework for Emarsys✨(2019)

#### Description:
https://github.com/noslopy/emarsys_test/files/3819796/Developer.homework._.2019.pdf

#### Solution:

* language: ruby 💎
* framework: sinatra 👨‍🎤
* persistent storage: postgreSQL 🗃️

So in this scenrio we have a separate single responsability service - a sinatra microservice - that manipulates issues in
an imaginary issue tracking software. The required function specified in the description is done by the issue model.

I dockerized the app to ease the configuration & setup.

Run the following commands to set up the development enviroment:

```bash
docker-compose build
docker-compose run web rake db:create
docker-compose run web rake db:migrate
docker-compose run web rake db:migrate RACK_ENV=test
docker-compose run web ruby test/endpoint/issues_test.rb
```

After I have submitted the first version that you can find as [v1.0.0](https://github.com/noslopy/emarsys_test/tree/v1.0.0),
I have made some adjustments because I skipped a couple things that I haven't found important enough for the task specified
above. Mostly formatting, error handling and the enforcement of a few principles.

So here is ✨✨✨[v1.0.1](https://github.com/noslopy/emarsys_test/tree/v1.0.1)✨✨✨