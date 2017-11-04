FactoryBot.define do
  factory :shopify_order, class: ShopifyAPI::Order do
    skip_create
    sequence(:id) { |n| n }
    email FFaker::Internet.email
    closed_at nil
    created_at Time.current
    updated_at Time.current
    number { rand(10_000..20_000) }
    note FFaker::Lorem.sentence
    token 'token'
    gateway 'Bank Deposit'
    test true
    total_price { rand(100.00..200.00) }
    subtotal_price { rand(100.00..200.00) }
    total_weight 0
    total_tax { rand(10.00..20.00) }
    taxes_included true
    currency 'USD'
    financial_status 'paid'
    confirmed true
    total_discounts { rand(100.00..200.00) }
    total_line_items_price { rand(100.00..200.00) }
    cart_token 'cart_token'
    buyer_accepts_marketing true
    name '#1'
    referring_site ''
    landing_site '/'
    cancelled_at nil
    cancel_reason nil
    total_price_usd { total_price }
    checkout_token 'checkout_token'
    reference nil
    location_id nil
    source_identifier nil
    source_url nil
    processed_at Time.current
    device_id nil
    browser_ip '127.0.0.1'
    landing_site_ref nil
    order_number '1'
    note_attributes []
    payment_gateway_names ['Bank Deposit']
    processing_method 'manual'
    checkout_id 6_974_564_679
    source_name 'web'
    fulfillment_status 'fulfilled'
    tags ''
    contact_email FFaker::Internet.email
    order_status_url 'https://checkout.shopify.com/someidentifier/checkouts/uniquehash/thank_you_token?key=somekeyvalue'
    refunds []
    discount_codes []
    customer { create(:shopify_customer) }
    user_id { customer.id }
    tax_lines []
    shipping_lines { [create(:shopify_shipping_line)] }
    billing_address []
    shipping_address []
    fulfillments []
    line_items []
  end
end
