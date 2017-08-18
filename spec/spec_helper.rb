require 'simplecov'
SimpleCov.start 'rails'

# Configure Rails Environment
ENV['RAILS_ENV'] ||= 'test'

begin
  require File.expand_path('../dummy/config/environment', __FILE__)
rescue LoadError
  puts %(
    Could not load dummy application.
    Please ensure you have run `bundle exec rake test_app`
  )
  abort
end

require 'pry'
require 'ffaker'
require 'rspec/rails'

require 'spree_shopify_importer/factories'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.fail_fast = false
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.before :each do
    Rails.cache.clear
  end

  config.before %i[each job] do
    ActiveJob::Base.queue_adapter = :test
  end
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }
