require 'spec_helper'

describe ShopifyImport::DataParsers::Fulfillments::BaseData, type: :service do
  let(:shopify_fulfillment) { create(:shopify_fulfillment) }
  subject { described_class.new(shopify_fulfillment) }

  describe '#shipment_number' do
    it 'creates number with fulfillment id' do
      expect(subject.shipment_number).to eq "SH#{shopify_fulfillment.id}"
    end
  end

  describe '#shipment_attributes' do
    let(:result) do
      {
        stock_location: Spree::StockLocation.last,
        tracking: shopify_fulfillment.tracking_number,
        state: :shipped
      }
    end

    it 'creates shopify stock location' do
      expect { subject.shipment_attributes }.to change(Spree::StockLocation, :count).by(1)
    end

    it 'returns hash of shipment attributes' do
      expect(subject.shipment_attributes).to eq result
    end

    context 'shipment states' do
      [
        { status: 'pending', spree_state: :pending },
        { status: 'success', spree_state: :shipped },
        { status: 'cancelled', spree_state: :canceled },
        { status: 'error', spree_state: :canceled },
        { status: 'failure', spree_state: :canceled }
      ].each do |shipment_hash|
        it "for shopify status #{shipment_hash[:status]} it sets state #{shipment_hash[:spree_state]}" do
          shipment = create(:shopify_fulfillment, status: shipment_hash[:status])
          parser = described_class.new(shipment)

          expect(parser.shipment_attributes[:state]).to eq shipment_hash[:spree_state]
        end
      end
    end
  end

  describe '#shipment_timestamps' do
    let(:result) do
      {
        created_at: shopify_fulfillment.created_at.to_datetime,
        updated_at: shopify_fulfillment.updated_at.to_datetime,
        shipped_at: shopify_fulfillment.created_at.to_datetime
      }
    end

    it 'returns hash of shipment timestamps' do
      expect(subject.shipment_timestamps).to eq result
    end
  end
end
