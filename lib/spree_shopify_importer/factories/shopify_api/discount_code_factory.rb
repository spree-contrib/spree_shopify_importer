FactoryBot.define do
  factory :shopify_discount_code, class: ShopifyAPI::DiscountCode do
    skip_create
    sequence(:id) { |n| n }
    price_rule_id 1
    amount 100.00
    sequence(:code) { |n| "CODE-#{n}" }
    type :fixed_amount
    created_at Time.current
    updated_at Time.current
  end
end
