source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.9'

gem 'aws-sdk-core'
gem 'charlock_holmes'
gem 'elasticsearch'
gem 'elasticsearch-model'
gem 'elasticsearch-persistence'
gem 'htmlentities'
gem 'iso_country_codes'
gem 'jbuilder'
gem 'nokogiri'
gem 'rack-contrib'
gem 'rake'
gem 'sanitize'
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'typhoeus'

group :production do
  gem 'airbrake'
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'rspec-rails'
  gem 'thin'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rubocop', '0.39.0', require: false
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end
