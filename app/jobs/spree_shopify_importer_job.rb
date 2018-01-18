class SpreeShopifyImporterJob < ApplicationJob
  queue_as { Spree::Config[:shopify_import_queue] }
end
