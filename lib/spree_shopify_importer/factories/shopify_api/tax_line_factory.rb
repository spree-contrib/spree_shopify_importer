FactoryBot.define do
  factory :shopify_tax_line, class: ShopifyAPI::TaxLine do
    skip_create
    title 'VAT'
    price 8.84
    rate 0.22
  end
end
