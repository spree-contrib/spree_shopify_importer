require 'spec_helper'

RSpec.describe ShopifyImport::Product, type: :module do
  subject { described_class }

  before { authenticate_with_shopify }

  it 'is inheriting from base' do
    expect(described_class.superclass).to eq ShopifyImport::Base
  end

  describe '.count', vcr: { cassette_name: 'shopify/product/count' } do
    let(:result) { { 'count' => 2 } }

    it 'returns number of products in shopify base' do
      expect(subject.count).to eq result
    end
  end

  describe '.all', vcr: { cassette_name: 'shopify/product/all' } do
    it 'finds all products in Shopify' do
      expect(subject.all.length).to eq 2
    end
  end
end
