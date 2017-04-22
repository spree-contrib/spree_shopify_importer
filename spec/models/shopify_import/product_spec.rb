require 'spec_helper'

RSpec.describe ShopifyImport::Product, type: :module do
  subject { described_class.new }

  before do
    Spree::Config[:shopify_api_key] = 'api_key'
    Spree::Config[:shopify_password] = 'password'
    Spree::Config[:shopify_shop_domain] = 'shop_domain'
  end

  it 'is inheriting from base' do
    expect(described_class.superclass).to eq ShopifyImport::Base
  end

  describe '#count', vcr: { cassette_name: 'shopify/product/count' } do
    let(:result) { { 'count' => 2 } }

    it 'returns number of products in shopify base' do
      expect(subject.count).to eq result
    end
  end

  describe '#find_all', vcr: { cassette_name: 'shopify/product/find_all' } do
    it 'find all products in shopify' do
      expect(subject.find_all.length).to eq 2
    end
  end
end
