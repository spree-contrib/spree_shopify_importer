[![Build Status](https://travis-ci.org/spark-solutions/spree_shopify_importer.svg?branch=master)](https://travis-ci.org/spark-solutions/spree_shopify_importer)
[![Code Climate](https://codeclimate.com/github/spark-solutions/spree_shopify_importer/badges/gpa.svg)](https://codeclimate.com/github/spark-solutions/spree_shopify_importer)
[![Test Coverage](https://codeclimate.com/github/spark-solutions/spree_shopify_importer/badges/coverage.svg)](https://codeclimate.com/github/spark-solutions/spree_shopify_importer/coverage)

SpreeShopifyImporter
====================

Introduction goes here.

## Installation

1. Add this extension to your Gemfile with this line:
  ```ruby
  gem 'spree_shopify_importer', github: 'spark-solutions/spree_shopify_importer'
  ```

2. Install the gem using Bundler:
  ```shell
  bundle install
  ```

3. Copy & run migrations
  ```shell
  bundle exec rails g spree_shopify_importer:install
  ```

4. Restart your server

  If your server was running, restart it so that it can find the assets properly.

## Testing

To run all the tests for the build, clone the repo and run:

```shell
bundle exec rake
```

This will generate a dummy app for testing, run rubocop style checker and rspec tests.

When testing your applications integration with this extension you may use its factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_shopify_importer/factories'
```

## Contributing

We welcome new pull requests!

Copyright (c) 2017 Spark Solutions, released under the New BSD License
