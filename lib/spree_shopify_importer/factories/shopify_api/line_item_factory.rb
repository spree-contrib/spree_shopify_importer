FactoryBot.define do
  factory :shopify_line_item, class: ShopifyAPI::LineItem do
    skip_create

    sequence(:id)
    variant_id { create(:shopify_variant).id }
    title FFaker::Product.product_name
    quantity 1
    price 20.00
    grams 7000
    sku 321
    variant_title FFaker::Product.product_name
    vendor 'test-store'
    fulfillment_service 'manual'
    product_id { create(:shopify_product).id }
    requires_shipping true
    taxable true
    gift_card false
    name 'test - 6'
    variant_inventory_management 'shopify'
    properties []
    product_exists true
    fulfillable_quantity 0
    total_discount 0.00
    fulfillment_status 'fulfilled'
    tax_lines nil
    origin_location nil
    destination_location nil
  end
end
