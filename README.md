[![Build Status](https://travis-ci.org/spark-solutions/spree_shopify_importer.svg?branch=master)](https://travis-ci.org/spark-solutions/spree_shopify_importer)
[![Code Climate](https://codeclimate.com/github/spark-solutions/spree_shopify_importer/badges/gpa.svg)](https://codeclimate.com/github/spark-solutions/spree_shopify_importer)
[![Test Coverage](https://codeclimate.com/github/spark-solutions/spree_shopify_importer/badges/coverage.svg)](https://codeclimate.com/github/spark-solutions/spree_shopify_importer/coverage)

SpreeShopifyImporter
====================

The SpreeShopifyImporter gem allows you to easily import data from Shopify store to Spree application.
It's compatible with Spree 3.2 and above.

Behind-the-scenes, this extension is using [Shopify API gem](https://github.com/Shopify/shopify_api).

Currently, it's in version 0.1.0. It has been tested with thousands of real life orders, but we welcome new pull requests!

## Installation

1. Add this extension to your Gemfile with this:
  ```ruby
  gem 'spree_shopify_importer', github: 'spark-solutions/spree_shopify_importer'
  gem 'spree_address_book', github: 'spree-contrib/spree_address_book'
  gem 'spree_auth_devise', '~> 3.3'

  ```

2. Install the gem using Bundler:
  ```shell
  bundle install
  ```

3. Copy & run migrations:
  ```shell
  bundle exec rails g spree_shopify_importer:install
  ```

4. Restart your server:

  If your server was running, restart it so that it can find the assets properly.
  
5. Setup credentials and change default values if needed.

## Getting Started

We are recommending using sidekiq for background processing with this stack of gems:

```ruby
gem 'sidekiq'
gem 'sidekiq-limit_fetch'
gem 'sidekiq-unique-jobs'
```

We also recommend having a limit **2** for import queue, due to API limit. Default queue name is **default** 
but it can be changed in **Spree::AppConfiguration** under *shopify_import_queue* key.

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
 SpreeShopifyImporter::InvokerJob.new.import!
```

or with credentials.

```ruby
 SpreeShopifyImporter::InvokerJob.new(credentials).import!
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
## Import Model

1. SpreeShopifyImporter::DataFeed - this model contains copy of JSON imported from shopify and association to spree object.

## Import Services

Import services are divided into four main parts. Each of them could be customized.

1. Data Fetchers are services which are fetching products, users, orders and collections from Shopify.

2. Importers are services which are saving Shopify data feeds (as shadow copy of import), and 
   starting a create or update action for spree object.
   
3. Data Savers are services which are saving spree objects, each of them has a parser method which can be 
   overridden to change update/create attributes and associations.
   
4. Data Parsers are services which are changing Shopify data to spree data.


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

## License

Spree Shopify Importer is copyright © 2015-2018
[Spark Solutions Sp. z o.o.][spark]. It is free software,
and may be redistributed under the terms specified in the
[LICENSE](LICENSE.md) file.

## About Spark Solutions
[![Spark Solutions](http://sparksolutions.co/wp-content/uploads/2015/01/logo-ss-tr-221x100.png)][spark]

Spree Shopify Importer is maintained and funded by [Spark Solutions Sp. z o.o.](http://sparksolutions.co?utm_source=github)
The names and logos are trademarks of Spark Solutions Sp. z o.o.

We are passionate about open source software.
We are [available for hire][spark].

[spark]:http://sparksolutions.co?utm_source=github
