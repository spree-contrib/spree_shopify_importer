require 'spec_helper'

RSpec.describe SpreeShopifyImporter::Connections::Order, type: :model do
  subject { described_class }

  before { authenticate_with_shopify }

  describe '.count', vcr: { cassette_name: 'shopify/order/count' } do
    let(:result) { { 'count' => 1 } }

    it 'returns number of customers in Shopify' do
      expect(subject.count).to eq result
    end
  end

  describe '.all', vcr: { cassette_name: 'shopify/order/all' } do
    it 'find all customers in Shopify' do
      expect(subject.all.length).to eq 1
    end
  end
end
