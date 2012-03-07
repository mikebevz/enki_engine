source 'https://rubygems.org'

# TODO remove these dependencies and specify the dependencies in enki-engine.gemspec and uncomment the line below
# gemspec

gem 'rails', '3.2.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# Bundle the extra gems:
gem 'RedCloth',       '~> 4.2.9', :require => 'redcloth'
gem 'aaronh-chronic', :require => 'chronic' # Fixes for 1.9.2

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test do
  gem 'database_cleaner'
  gem 'cucumber-rails',    :require => false
  gem 'cucumber-websteps', :require => false
  gem 'factory_girl'
  gem 'rspec'
  gem 'nokogiri', '~> 1.5.0'
  gem 'webrat'
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :development, :test do
  gem 'rspec-rails'
end
