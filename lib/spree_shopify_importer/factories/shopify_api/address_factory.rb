FactoryGirl.define do
  factory :shopify_address, class: ShopifyAPI::Address do
    skip_create
    id 1
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    company { generate(:random_string) }
    address1 'Some Street'
    address2 'Apartment 3'
    city 'Some city'
    province 'New York'
    country 'United States'
    zip '11223'
    phone '12345678901'
    name 'John Smith'
    province_code 'NY'
    country_code 'US'
    country_name 'United States'
    default true
  end
end
