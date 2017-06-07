require 'spec_helper'

RSpec.describe ShopifyImport::DataParsers::CustomCollections::BaseData, type: :service do
  let(:shopify_custom_collection) { create(:shopify_custom_collection) }
  subject { described_class.new(shopify_custom_collection) }

  describe '#taxon_attributes' do
    let(:result) do
      {
        name: shopify_custom_collection.title,
        permalink: shopify_custom_collection.handle,
        description: shopify_custom_collection.body_html
      }
    end

    it 'returns hash of attributes' do
      expect(subject.taxon_attributes).to eq result
    end
  end

  describe '#product_ids' do
    let!(:shopify_product) { create(:shopify_product) }
    let!(:spree_product) { create(:product) }
    let!(:shopify_data_feed) do
      create(:shopify_data_feed,
             spree_object: spree_product,
             shopify_object_id: shopify_product.id,
             shopify_object_type: shopify_product.class.to_s)
    end

    before do
      allow(shopify_custom_collection).to receive(:products).and_return([shopify_product])
    end

    it 'returns array of products ids' do
      expect(subject.product_ids).to contain_exactly(spree_product.id)
    end
  end
end
