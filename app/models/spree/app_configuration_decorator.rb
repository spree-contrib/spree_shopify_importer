module Spree
  module AppConfigurationDecorator
    def self.prepended(base)
      base.preference :shopify_api_key, :string
      base.preference :shopify_shop_domain, :string
      base.preference :shopify_token, :string
      base.preference :shopify_rescue_limit, :integer, default: 5
      base.preference :shopify_current_credentials, :hash
      base.preference :shopify_import_queue, :string, default: 'default'
    end
  end
end

::Spree::AppConfiguration.prepend(Spree::AppConfigurationDecorator)
