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

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'rollbar'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'letter_opener'
end

group :development, :test do
  gem 'byebug'
  gem 'annotate', github: 'ctran/annotate_models'
end
