FactoryBot.define do
  factory :shopify_data_feed, class: Shopify::DataFeed do
    sequence(:shopify_object_id)
    shopify_object_type 'ShopifyAPI::Product'
    sequence(:spree_object_id)
    spree_object_type 'Spree::Product'
    data_feed ''
  end
end
