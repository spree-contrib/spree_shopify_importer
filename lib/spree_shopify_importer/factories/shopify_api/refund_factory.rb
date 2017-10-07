FactoryGirl.define do
  factory :shopify_refund, class: ShopifyAPI::Refund do
    skip_create
    sequence(:id) { |n| n }
    sequence(:order_id) { |n| n }
    note 'it broke during shipping'
    restock true
    sequence(:user_id) { |n| n }
    processed_at '2017-01-05T15:40:07-05:00'
    created_at '2017-01-05T15:40:07-05:00'
    refund_line_items []
    transactions []
  end
end
