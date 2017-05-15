require 'spec_helper'

RSpec.describe ShopifyImport::Products::DataParsers::BaseData, type: :service do
  subject { described_class.new(shopify_product) }
  let!(:shipping_category) { create(:shipping_category, name: 'ShopifyImported') }
  let(:shopify_product) { create(:shopify_product) }

  describe '#product_attributes' do
    context 'with sample product' do
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

      it 'prepares hash of attributes' do
        expect(subject.product_attributes).to eq product_attributes
      end
    end
  end

  describe '#product_tags' do
    let(:product_tags) { shopify_product.tags }

    it 'prepares list tags' do
      expect(subject.product_tags).to eq product_tags
    end
  end

  describe '#option_types' do
    let(:shopify_product) { create(:shopify_product_multiple_variants, variants_count: 2, options_count: 2) }
    let(:option_types) do
      {
        shopify_product.options.first.name.downcase => shopify_product.options.first.values,
        shopify_product.options.last.name.downcase => shopify_product.options.last.values
      }
    end

    it '#option_types' do
      expect(subject.option_types).to eq option_types
    end
  end
end
