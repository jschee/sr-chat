source 'https://rubygems.org'

ruby '2.6.6'
# CORE
gem 'rails', '6.0.3.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise'
# gem 'omniauth'

# TOOLING
gem 'redis'
# gem 'sidekiq'
# gem 'sidekiq-status', "~> 1.1"
# gem 'recaptcha'
# gem 'bcrypt'

# ASSETS AND DELIVERY
gem 'sassc-rails'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'image_processing', '~> 1.2'
gem "stimulus_reflex"
gem "cable_ready", "~> 4.3"
gem "aws-sdk-s3", require: false
gem "pagy", "~> 3.5"

# API SUPPORT
gem 'jbuilder', '~> 2.7'

# MAILING
# gem 'mailgun_rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'capybara'
  gem 'webdrivers', '~> 4.0' # run selenium tests which include chromes and firefox browser drivers
  gem 'bullet'
  gem 'annotate'
  gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'master'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'guard-livereload', '~> 2.5', require: false
  gem "letter_opener"
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
