source 'https://rubygems.org'
ruby '2.2.4'

gem 'rails', '4.2.5.1'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
# gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'devise'
gem 'activeadmin', github: 'activeadmin'
gem 'cancancan', '~> 1.10'
gem 'doorkeeper'
gem 'doorkeeper-grants_assertion',
    github: 'doorkeeper-gem/doorkeeper-grants_assertion', branch: 'master'
gem 'apipie-rails', github: 'Apipie/apipie-rails'
gem 'maruku'
gem 'geocoder'
gem 'country_select'
gem 'rails-settings-cached'
gem 'activeadmin_settings_cached'
gem 'aasm'
gem 'postmark-rails'
gem 'rack-cors', require: 'rack/cors'
gem 'fog', require: 'fog/aws'
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem 'rmagick'
gem 'carrierwave-base64'

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'rollbar'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'letter_opener'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
end

group :development, :test do
  gem 'byebug'
  gem 'annotate', github: 'ctran/annotate_models'
end

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'oauth2'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner'
end
