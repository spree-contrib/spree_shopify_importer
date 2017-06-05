require 'spec_helper'

RSpec.describe ShopifyImport::Customer, type: :module do
  subject { described_class.new }

  before do
    Spree::Config[:shopify_api_key] = 'api_key'
    Spree::Config[:shopify_password] = 'password'
    Spree::Config[:shopify_shop_domain] = 'shop_domain.myshopify.com'
  end

  describe '#count', vcr: { cassette_name: 'shopify/customer/count' } do
    let(:result) { { 'count' => 1 } }

    it 'returns number of customers in shopify base' do
      expect(subject.count).to eq result
    end
  end

  describe '#find_all', vcr: { cassette_name: 'shopify/customer/find_all' } do
    it 'find all customers in shopify' do
      expect(subject.find_all.length).to eq 1
    end
  end
end
