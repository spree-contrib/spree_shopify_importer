# encoding: UTF-8

lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_shopify_importer/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_shopify_importer'
  s.version     = SpreeShopifyImporter::VERSION
  s.summary     = 'Import your old Shopify store into spree'
  s.description = 'Import Shopify store to spree for easier migration.'
  s.required_ruby_version = '>= 2.2.2'

  s.authors   = ['Viktor Fonic']
  s.email     = ['viktor.fonic@gmail.com']
  s.homepage  = 'https://github.com/spark-solutions/spree_shopify_importer'
  s.license = 'BSD-3-Clause'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 3.1.0', '< 4.0'
  s.add_dependency 'shopify_api', '>= 4.2.2'
  s.add_dependency 'activeresource'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-rubocop'
  s.add_development_dependency 'guard-spring'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'spring-commands-rspec'
  s.add_development_dependency 'spring-commands-rubocop'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
