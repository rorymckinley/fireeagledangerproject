# Setup

- If you don't already have one, you will need a Twitter account.
- Go to https://dev.twitter.com/apps/new and register an app - pick Browser as the type of application. Twitter will generate a consumer token and a consumer secret that you will need to use when accessing the API.
- You will need to create a Heroku instance to deploy to <http://devcenter.heroku.com/articles/quickstart>.
- The code is geared around a Heroku deployment - once you have created a Heroku instance, but before your first deploy, add the following config variables (<http://devcenter.heroku.com/articles/config-vars>:
  * CONSUMER_TOKEN (set to the value of the consumer token provided by Twitter)
  * CONSUMER_SECRET (set to the value of the consumer secret provided by Twitter)
  * USERNAME (the username for Basic HTTP auth)
  * PASSWORD (the password for Basic HTTP auth)
- After your first deploy, you will need to run migrations to set up the database. The rake task is migrations:production:up
