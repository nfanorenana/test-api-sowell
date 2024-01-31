# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.6"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "7.0.4"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "6"
# Use Active Model has_secure_password
gem "bcrypt", "~> 3.1.7"
# Enumerated attributes with I18n and ActiveRecord
gem "enumerize"
# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem "jwt"
# JSON serialization used to manage jsonb with ActiveRecord
gem "oj"
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"
# Use and follow the JSON:API specifications
# gem 'jsonapi.rb'
# Authorization library which restricts what resources a given user is allowed to access.
gem "cancancan"
# For searching purposes
gem "ransack"
# For stylish Graph APIs
gem "graphiti-rails"
# For automatic ActiveRecord pagination
gem "kaminari"
# Push images to CDN
gem "cloudinary"
# For building XLS files
gem "spreadsheet"
# For communication with AWS-S3 compatible services
gem "aws-sdk-s3", require: false

group :development, :test do
  # Fast implementation of the standard debugger
  gem "debase"
  # Shim to load environment variables from .env into ENV in development.
  gem "dotenv-rails"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  # Establish communication between the debugger engine and IDE
  gem "ruby-debug-ide"
  # Code formater
  gem "rubocop-rails", "~> 2.16"
  # Fixtures replacement with a straightforward definition syntax
  gem "factory_bot_rails"
  # https://rspec.info/
  gem "rspec-rails", ">= 3.9.0"
  # Rspec matchers for json api
  gem "jsonapi-rspec"
  # For seeding and creating fake data
  gem "faker"
end

group :test do
  gem "rack-test"
  # Cleans db arround each test
  gem "database_cleaner-active_record"
  # For stubbing requests
  gem "webmock"
  # Lets you name your tests and group them together using English.
  gem "shoulda-context"
  # Cucumber for test
  gem "cucumber-rails"
end

group :development do
  gem "listen", "~> 3.3"
end

group :production do
  # Adds autoscale dyno capabilities for Heroku
  # gem 'rails_autoscale_agent'
  # Manages heroku router forced timeout so that Puma does not maintain uneeded threads alive
  gem "rack-timeout"

  # Heroku ruby metrics
  gem "barnes"

  # FIXME: Search for memory leaks then remove the following gem https://devcenter.heroku.com/articles/ruby-memory-use#detecting-a-problem
  # Sets up a rolling worker restart of your Puma workers
  gem "puma_worker_killer"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
