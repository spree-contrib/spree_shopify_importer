require 'spec_helper'

RSpec.describe ShopifyImport::Products::DataParsers::BaseData, type: :service do
  describe '.prepare_data' do
    subject { described_class.new(shopify_product) }

    context 'with sample product' do
      let!(:shipping_category) { create(:shipping_category, name: 'ShopifyImported') }
      let(:shopify_product) { create(:shopify_product) }
      let(:product_tags) { shopify_product.tags }
      let(:product_attributes) do
        {
          name: shopify_product.title,
          description: shopify_product.body_html,
          available_on: shopify_product.published_at,
          slug: shopify_product.handle,
          price: 0,
          created_at: shopify_product.created_at,
          shipping_category: shipping_category
        }
      end

      it 'creates properly formatted hash of attributes' do
        expect(subject.product_attributes).to eq product_attributes
      end

      it 'creates properly formatted tags list' do
        expect(subject.product_tags).to eq product_tags
      end
    end
  end
end
