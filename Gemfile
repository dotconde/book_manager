source "https://rubygems.org"

gem "rails", "~> 7.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# Authentication & Authorization
gem "devise", "~> 4.9"
gem "devise-jwt", "~> 0.12"
gem "pundit", "~> 2.4"

# API
gem "jsonapi-serializer", "~> 2.2"
gem "kaminari", "~> 1.2"
gem "rack-cors", "~> 2.0"

gem "faker", "~> 3.8"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 7.0"
  gem "factory_bot_rails", "~> 6.4"
  gem "rubocop-rails-omakase", require: false
  gem "brakeman", require: false
end
