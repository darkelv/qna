source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2', '>= 1.2.3'

# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'cocoon'
gem "octokit"

# search
gem 'thinking-sphinx', "~> 4.0"
gem 'mysql2', '~> 0.4.10', :platform => :ruby

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

#active_job
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false

#api
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'oj'

#auth
gem 'devise'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-facebook'

#authorization
gem 'cancancan'

#views
gem 'bootstrap'
gem 'gon'
gem 'simple_form'
gem 'slim-rails'
gem 'mini_racer'

#build
gem 'unicorn'

#cache
gem 'redis-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.0'
  gem 'factory_bot_rails'

  # Pry stuff
  gem 'pry-rails'
  gem 'pry-pretty-numeric' # 1_234_768
  gem 'pry-doc' # ? loop
  gem 'pry-docmore'
  gem "pry-stack_explorer" # show-stack in console
  gem 'pry-byebug' # step, next, finish, continue, break
  gem 'awesome_print' # nice inspection in console
  gem 'dotenv-rails'
  gem 'faker'
  gem "letter_opener"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'i18n-debug', '~> 1.2'
  gem 'capybara-email'
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-redis'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
