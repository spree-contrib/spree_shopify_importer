require 'spec_helper'

RSpec.describe SpreeShopifyImporter::DataParsers::Products::BaseData, type: :service do
  subject { described_class.new(shopify_product) }
  let!(:shipping_category) { create(:shipping_category, name: I18n.t(:shopify)) }
  let(:shopify_product) { create(:shopify_product) }

  describe '#attributes' do
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
        expect(subject.attributes).to eq product_attributes
      end
    end
  end

  describe '#tags' do
    let(:product_tags) { shopify_product.tags }

    it 'prepares list tags' do
      expect(subject.tags).to eq product_tags
    end
  end

  describe '#options' do
    let(:shopify_product) { create(:shopify_product_multiple_variants, variants_count: 2, options_count: 2) }

    it '#options' do
      expect(subject.options).to eq shopify_product.options
    end
  end
end
