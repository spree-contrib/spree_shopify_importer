require 'spec_helper'

describe ShopifyImport::DataParsers::InventoryUnits::BaseData, type: :service do
  let!(:spree_shipment) { create(:shipment) }
  let!(:shopify_line_item) { create(:shopify_line_item) }
  let!(:spree_variant) { create(:variant) }
  let!(:spree_line_item) { create(:line_item, order: spree_shipment.order, variant: spree_variant) }

  subject { described_class.new(shopify_line_item, spree_shipment) }

  before do
    create(:shopify_data_feed,
           spree_object: spree_variant,
           shopify_object_type: 'ShopifyAPI::Variant',
           shopify_object_id: shopify_line_item.variant_id)
  end

  describe '#attributes' do
    let!(:result) do
      {
        order: spree_shipment.order,
        variant: spree_variant,
        line_item: spree_line_item,
        state: :on_hand
      }
    end

    it 'returns hash od inventory unit attributes' do
      expect(subject.attributes).to eq result
    end

    context 'when shipment is shipped' do
      let!(:spree_shipment) { create(:shipment, state: :shipped) }

      it 'returns hash od inventory unit attributes' do
        expect(subject.attributes[:state]).to eq :shipped
      end
    end
  end

  describe '#line_item' do
    it 'returns line item' do
      expect(subject.line_item).to eq spree_line_item
    end
  end
end
