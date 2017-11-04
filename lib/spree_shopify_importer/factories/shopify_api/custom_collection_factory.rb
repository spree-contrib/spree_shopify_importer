FactoryBot.define do
  factory :shopify_custom_collection, class: ShopifyAPI::CustomCollection do
    skip_create
    sequence(:id) { |n| n }
    title FFaker::Product.product
    handle FFaker::Internet.slug
    updated_at Time.current
    published_at Time.current
    sort_order 'alpha-desc'
    template_suffix nil
    published_scope 'global'
    body_html FFaker::Lorem.paragraphs(2)
  end
end
