source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bootsnap", require: false
gem "rack-cors"
gem "devise"
gem "devise-jwt"
gem 'warden-jwt_auth', '~> 0.6.0'
gem "jsonapi-serializer"
gem "rswag"
gem 'pagy', '~> 6.0'
gem 'graphql'
gem 'graphiql-rails', group: :development

gem 'actionpack-action_caching'

group :development, :test do

  gem "dotenv-rails"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
  gem "rswag-specs"
end

group :test do
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "codecov", require: false
  gem "simplecov", require: false
  gem "simplecov-cobertura"
end

gem "rolify"

gem "sprockets-rails", "~> 3.4"

gem "pundit", "~> 2.3"

gem "brakeman", "~> 6.0", group: :development
gem "bundler-audit", "~> 0.9.1"
gem "rubocop", "~> 1.56"
