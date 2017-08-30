require 'spec_helper'

describe ShopifyImport::Importers::OrderImporter, type: :service do
  subject { described_class.new(resource) }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/importers/order_importer' } do
    let!(:shopify_order) { ShopifyAPI::Order.find(5_182_437_124) }
    let!(:user) { create(:user) }
    let!(:user_data_feed) do
      create(:shopify_data_feed,
             spree_object: user,
             shopify_object_id: shopify_order.customer.id,
             shopify_object_type: 'ShopifyAPI::Customer')
    end
    let(:resource) { shopify_order.to_json }

    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(5)
    end

    it 'creates spree orders' do
      expect { subject.import! }.to change(Spree::Order, :count).by(1)
    end
  end
end
