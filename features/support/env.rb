require 'rspec'
require 'cucumber'
require 'httparty'
require 'httparty/request'
require 'httparty/response/headers'
require 'faker'
require 'cpf_faker'
require 'byebug'

ENVIRONMENT = ENV['ENVIRONMENT']

CONFIG = YAML.load_file(File.dirname(__FILE__) + "/config/#{ENVIRONMENT}.yml")

Dir[File.join(File.dirname(__FILE__), '../services/*_services.rb')].each { |file| require_relative file }

# require 'cucumber/rails'

# ActionController::Base.allow_rescue = false

# begin
#   DatabaseCleaner.strategy = :transaction
# rescue NameError
#   raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
# end

# Cucumber::Rails::Database.javascript_strategy = :truncation
