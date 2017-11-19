[![Build Status](https://travis-ci.org/spark-solutions/spree_shopify_importer.svg?branch=master)](https://travis-ci.org/spark-solutions/spree_shopify_importer)
[![Code Climate](https://codeclimate.com/github/spark-solutions/spree_shopify_importer/badges/gpa.svg)](https://codeclimate.com/github/spark-solutions/spree_shopify_importer)
[![Test Coverage](https://codeclimate.com/github/spark-solutions/spree_shopify_importer/badges/coverage.svg)](https://codeclimate.com/github/spark-solutions/spree_shopify_importer/coverage)

SpreeShopifyImporter
====================

The SpreeShopifyImporter gem allows users to easily import data from Shopify store to Spree application.
It's compatible with Spree 3.2 and up.

Behind-the-scenes, extension is using [Shopify API gem](https://github.com/Shopify/shopify_api).

Currently, it's in version alpha. We welcome new pull requests!

## Installation

1. Add this extension to your Gemfile with this line:
  ```ruby
  gem 'spree_shopify_importer', github: 'spark-solutions/spree_shopify_importer'
  gem 'spree_address_book', github: 'spree-contrib/spree_address_book'
  gem 'spree_auth_devise', '~> 3.3'
  gem 'curb'

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

## Getting Started

## Import Customizations

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
