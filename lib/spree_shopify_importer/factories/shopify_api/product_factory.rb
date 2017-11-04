FactoryBot.define do
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
    variants []
    images []

    transient do
      variants_count 1
      options_count 1
    end

    factory :shopify_product_single_variant do
      variants { build_list(:shopify_variant, 1) }
      options { build_list(:shopify_single_option, 1) }
      images { build_list(:shopify_image, 1) }
    end

    factory :shopify_product_multiple_variants do
      after(:build) do |product, evaluator|
        product.variants = build_list(:shopify_variant, evaluator.variants_count)
        product.images = build_list(:shopify_image, evaluator.variants_count)
        product.options = Array.new(evaluator.options_count) do |i|
          variant = product.variants[i]
          values = [variant.option1, variant.option2, variant.option3]
          build(:shopify_base_option, options_count: evaluator.variants_count, position: i + 1, values: values)
        end
      end
    end
  end
end
