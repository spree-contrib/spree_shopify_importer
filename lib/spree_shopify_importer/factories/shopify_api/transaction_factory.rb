FactoryGirl.define do
  factory :shopify_transaction, class: ShopifyAPI::Transaction do
    skip_create
    sequence(:id) { |n| n }
    amount { rand(100.00..200.00) }
    authorization nil
    created_at Time.current
    device_id nil
    gateway 'Bank Deposit'
    source_name 'web'
    kind 'sale'
    order { create(:shopify_order) }
    receipt 'testcase'
    status 'success'
    currency 'USD'
    user_id { order.customer.id }
  end
end
