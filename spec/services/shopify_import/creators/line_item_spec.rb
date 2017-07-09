require 'spec_helper'

describe ShopifyImport::Creators::LineItem, type: :service do
  subject { described_class.new(shopify_line_item, shopify_order, spree_order) }

  before { authenticate_with_shopify }

  describe '#save', vcr: { cassette_name: 'shopify/base_order' } do
    let(:spree_order) { create(:order) }
    let(:shopify_order) { ShopifyAPI::Order.find(5_182_437_124) }
    let(:shopify_line_item) { shopify_order.line_items.first }
    let(:variant) { create(:variant) }
    let!(:data_feed) do
      create(:shopify_data_feed,
             spree_object: variant,
             shopify_object_id: shopify_line_item.variant_id,
             shopify_object_type: 'ShopifyAPI::Variant')
    end
    let(:line_item) { Spree::LineItem.find_by(variant_id: variant.id) }

    it 'creates spree line item' do
      expect { subject.save }.to change(Spree::LineItem, :count).by(1)
    end

    context 'associations' do
      before { subject.save }

      it 'assigns proper variant to spree line item' do
        expect(line_item.variant).to eq variant
      end

      it 'assigns a line item to order' do
        expect(line_item.order).to eq spree_order
      end
    end

    context 'line item attributes' do
      before { subject.save }

      it 'sets quantity' do
        expect(line_item.quantity).to eq shopify_line_item.quantity
      end

      it 'sets price' do
        expect(line_item.price).to eq shopify_line_item.price.to_d
      end

      it 'sets currency' do
        expect(line_item.currency).to eq shopify_order.currency
      end

      it 'sets adjustment_total' do
        expect(line_item.adjustment_total).to eq(- shopify_line_item.total_discount.to_d)
      end
    end
  end
end
