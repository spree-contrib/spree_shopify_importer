require 'spec_helper'

describe ShopifyImport::Creators::InventoryUnitsCreator, type: :service do
  subject { described_class.new(shopify_line_item, spree_shipment) }
  before { authenticate_with_shopify }

  describe '#save!', vcr: { cassette_name: 'shopify/base_order' } do
    let!(:spree_shipment) { create(:shipment) }
    let!(:shopify_order) { ShopifyAPI::Order.find(5_182_437_124) }
    let!(:shopify_line_item) { shopify_order.line_items.first }
    let!(:spree_variant) { create(:variant) }
    let!(:spree_line_item) { create(:line_item, order: spree_shipment.order, variant: spree_variant) }

    before do
      create(:shopify_data_feed,
             spree_object: spree_variant,
             shopify_object_type: 'ShopifyAPI::Variant',
             shopify_object_id: shopify_line_item.variant_id)
    end

    it 'creates inventory units' do
      expect { subject.save! }.to change(Spree::InventoryUnit, :count).by(3)
    end

    context 'sets inventory unit associations' do
      let(:inventory_units) { Spree::InventoryUnit.last(3) }

      before { subject.save! }

      it 'variant' do
        expect(inventory_units.pluck(:variant_id).uniq).to contain_exactly(spree_variant.id)
      end

      it 'line item' do
        expect(inventory_units.pluck(:line_item_id).uniq).to contain_exactly(spree_line_item.id)
      end

      it 'order' do
        expect(inventory_units.pluck(:order_id).uniq).to contain_exactly(spree_shipment.order.id)
      end
    end

    context 'sets inventory unit attributes' do
      let(:inventory_units) { Spree::InventoryUnit.last(3) }

      before { subject.save! }

      it 'state' do
        expect(inventory_units.pluck(:state).uniq).to contain_exactly 'on_hand'
      end
    end
  end
end
