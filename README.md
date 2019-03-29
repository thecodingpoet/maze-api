# BACKEND API

## Installation

Follow these easy steps to install and start the app:

### Pre-requisites
- Ruby >= 2.5.1
- Ruby on Rails >= 5.2.3
- PostgreSQL

### Set up Rails app

First, install the gems required by the application:

  bundle

Next, execute the database migrations/schema setup:

	bundle exec rails db:setup


### Start the app

Start the Rails app to see the application:

    bundle exec rails server

You can find your app now by pointing your browser to [http://localhost:3000](http://localhost:3000)

### Running specs
    bundle exec rspec
