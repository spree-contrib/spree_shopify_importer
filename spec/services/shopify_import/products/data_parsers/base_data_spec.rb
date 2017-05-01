require 'spec_helper'

RSpec.describe ShopifyImport::Products::DataParsers::Create, type: :service do
  describe '.prepare_data' do
    subject { described_class.to_spree(shopify_product) }

    context 'with sample product' do
      let!(:shipping_category) { create(:shipping_category, name: 'ShopifyImported') }
      let(:shopify_product) { create(:shopify_product) }
      let(:result) do
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
        expect(subject).to eq result
      end
    end
  end
end
