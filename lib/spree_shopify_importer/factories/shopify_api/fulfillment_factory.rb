FactoryBot.define do
  factory :shopify_fulfillment, class: ShopifyAPI::Fulfillment do
    skip_create

    status 'success'
    created_at DateTime.current
    updated_at DateTime.current
    service 'manual'
    tracking_company nil
    tracking_number 'track_code'
    tracking_numbers ['track_code']
    tracking_url 'http://www.google.com/search?q=track_code'
    tracking_urls ['http://www.google.com/search?q=track_code']
    receipt nil
    line_items { create_list(:shopify_line_item, 1) }
    order { create(:shopify_order) }

    after(:build) do |evaluator, fulfillment|
      fulfillment.line_items = evaluator.order.line_items if evaluator.order
    end
  end
end
