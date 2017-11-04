FactoryBot.define do
  factory :shopify_image, class: ShopifyAPI::Image do
    skip_create

    sequence(:id)
    sequence(:position)
    product_id 632_910_392
    variant_ids [808_950_810]
    src 'http://static.shopify.com/products/ipod-nano.png'
    width 600
    height 480
    created_at '2012-03-13T16:09:58-04:00'
    updated_at '2012-03-13T16:09:58-04:00'
  end
end
