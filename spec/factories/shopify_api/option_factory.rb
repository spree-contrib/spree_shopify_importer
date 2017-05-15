FactoryGirl.define do
  factory :shopify_base_option, class: ShopifyAPI::Option do
    skip_create
    sequence(:id) { |n| n }
    sequence(:product_id) { |n| n }
    sequence(:name) { |n| "Option ##{n}" }
    sequence(:position, 1)

    transient do
      options_count 1
    end
    factory :shopify_single_option do
      values ['Default Option']
    end

    factory :shopify_multiple_option do
      after(:build) do |base_option, evaluator|
        base_option.values = Array.new(evaluator.options_count) { |i| "value ##{i}" }
        base_option.position = evaluator.position if evaluator.position
      end
    end
  end
end
