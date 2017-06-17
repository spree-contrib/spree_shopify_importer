FactoryGirl.define do
  factory :shopify_shipping_line, class: ShopifyAPI::ShippingLine do
    skip_create
    sequence(:id) { |n| n }
    title 'UPS'
    code 'UPS'
    price { rand(10.00..15.00) }
    source 'shopify'
    phone nil
    carrier_identifier nil
    tax_lines []
    rate 0.22
  end
end
