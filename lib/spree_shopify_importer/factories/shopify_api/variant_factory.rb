FactoryGirl.define do
  factory :shopify_variant, class: ShopifyAPI::Variant do
    skip_create
    sequence(:id) { |n| 219_898_982 + n }
    sequence(:title) { |n| "Variant ##{n}" }
    sequence(:sku) { |n| "SKU-#{n}" }
    price 25.95
    sequence(:position) { |n| n }
    grams { rand(0..1000) }
    weight 0.0
    weight_unit 'lb'
    inventory_policy 'deny'
    compare_at_price nil
    fulfillment_service 'manual'
    inventory_management 'shopify'
    option1 FFaker::Name.name
    option2 FFaker::Name.name
    option3 FFaker::Name.name
    requires_shipping true
    taxable true
    barcode ''
    inventory_quantity 0
    old_inventory_quantity 0
    image_id nil
  end
end
