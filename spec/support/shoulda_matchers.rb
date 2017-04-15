require 'shoulda/matchers'
require 'spree/testing_support/shoulda_matcher_configuration'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
