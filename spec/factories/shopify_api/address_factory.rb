FactoryGirl.define do
  factory :shopify_address, class: ShopifyAPI::Address do
    skip_create
    sequence(:id) { |n| 219_898_982 + n }
    first_name FFaker::Name.first_name
    last_name FFaker::Name.last_name
    company FFaker::Company.name
    address1 FFaker::Address.street_address
    address2 FFaker::Address.street_address
    phone FFaker::PhoneNumber.phone_number
    city FFaker::Address.city
    zip FFaker::AddressAU.postcode
    province FFaker::AddressUS.state
    province_code ''
    country FFaker::Address.country
    country_code FFaker::AddressUS.country_code
    created_at '2011-10-20T14:05:13-04:00'
    updated_at '2011-10-20T14:05:13-04:00'

    before(:create) do |address, evaluator|
      address.country_name = address.country
    end
  end
end
