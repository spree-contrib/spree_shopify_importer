require 'spec_helper'

describe SpreeShopifyImporter::Importers::ShipmentImporter, type: :service do
  let!(:parent_feed) { create(:shopify_data_feed, data_feed: shopify_order.to_json) }
  let!(:spree_order) { create(:order) }

  subject { described_class.new(fulfillment, parent_feed, spree_order) }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify/importers/shipment_importer/import' } do
    let(:shopify_order) { ShopifyAPI::Order.find(5_182_437_124) }
    let(:fulfillment) { shopify_order.fulfillments.first }

    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(1)
    end

    it 'creates spree shipment' do
      expect { subject.import! }.to change(Spree::Shipment, :count).by(1)
    end
  end
end
