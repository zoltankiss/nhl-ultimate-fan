# NHL Ultimate Fan

To view in production:

https://nhlultimatefanviewer.herokuapp.com/

## How to run locally

Clone both this repo and the frontend React app: https://github.com/zoltankiss/nhl-ultimate-fan-frontend

Step #1:
* `bundle install`
* `bin/rails db:create`
* `bin/rails db:migrate`

Step #2: open four seperate tabs.

In one, start the frontend. In another, run: `bin/rails s`.
In yet another, run: `bundle exec rake resque:scheduler`.
Finnally, in the last one, run: `QUEUE=* bundle exec rake resque:work`.

When an NHL game starts you should see live data!