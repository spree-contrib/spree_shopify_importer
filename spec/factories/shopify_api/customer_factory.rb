FactoryGirl.define do
  factory :shopify_customer, class: ShopifyAPI::Customer do
    skip_create
    sequence(:id) { |n| n }
    email FFaker::Internet.email
    first_name FFaker::Name.first_name
    last_name FFaker::Name.last_name
    created_at '2011-10-20T14:05:13-04:00'
    updated_at '2011-10-20T14:05:13-04:00'
  end
end
