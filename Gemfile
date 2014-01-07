source 'https://rubygems.org'

gem 'rails', '3.2.14'
ruby "1.9.3"


gem 'rails-i18n'
gem 'pry'
gem 'nokogiri'
gem 'pismo'
gem "ruby-readability", :require => 'readability'
gem "ruby-filemagic"

gem 'sanitize'


#gem 'rack-cache', :require => 'rack/cache'
#gem 'dragonfly', '~>0.9.15'
#gem 'rmagick'
#gem 'jquery-ui-rails'
# gem 'jquery-rails'
#gem "twitter-bootstrap-rails", :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'


group :production do
 gem "pg"
 gem 'newrelic_rpm'
end

group :development, :test do
  gem 'sqlite3'
  gem 'debugger'
  gem 'rspec-rails', '~> 3.0.0.beta'
end

group :test do
  gem "capybara"
  gem 'ruby-prof'
  gem 'capybara-webkit', git: 'git://github.com/thoughtbot/capybara-webkit.git'
  gem "launchy"
  gem "selenium-webdriver"
  gem 'single_test'
end


group :assets do
  gem 'therubyracer', :platforms => :ruby
end


