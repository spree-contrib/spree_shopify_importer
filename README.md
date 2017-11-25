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

We are recommending using sidekiq for background processing with this stack of gems

```ruby
gem 'sidekiq'
gem 'sidekiq-limit_fetch'
gem 'sidekiq-unique-jobs'
```

We also recommend having a limit **2** for import queue, due to API limit. Default queue name is **default** 
but it can be change in Spree::AppConfiguration under shopify_import_queue key.

### Default values
   
All default values are saved in Spree::AppConfiguration
   
- ShopifyAPI credentials - used for api authorization.
  * shopify_api_key - nil
  * shopify_password - nil
  * shopify_shop_domain - nil
  * shopify_token - nil
- Import Rescue Limit - used for retrying API errors, for example API limit hit.
  * shopify_rescue_limit - 5
- Import Queue Name
  * shopify_import_queue - 'default'
  
   
### Import

Currently, you need to have access to the console to start the import.

1. To start import, in console run:

With default values

```ruby
 ShopifyImport::InvokerJob.new.import!
```

or with credentials.

```ruby
 ShopifyImport::InvokerJob.new(credentials).import!
```

Where credentials could have two formats:

```ruby
    {
      credentials: {
        api_key: 'api_key', 
        password: 'password',
        shop_domain: 'shop_domain'
      }
    }
```

or 

```ruby
    {
      credentials: {
        token: 'token',
        shop_domain: 'shop_domain'
      }
    }
```
## Import Customization

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
