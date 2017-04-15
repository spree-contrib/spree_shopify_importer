FactoryGirl.define do
  factory :shopify_product, class: ShopifyAPI::Product do
    skip_create
    sequence(:id) { |n| n }
    title FFaker::Product.product_name
    body_html FFaker::Lorem.paragraph
    vendor FFaker::Product.brand
    product_type 'boots'
    handle FFaker::Internet.slug
    template_suffix ''
    published_scope 'global'
    tags 'Emotive, Flash Memory, MP3, Music'
    created_at '2011-10-20T14:05:13-04:00'
    updated_at '2011-10-20T14:05:13-04:00'
    published_at '2011-10-20T14:05:13-04:00'
  end
end
