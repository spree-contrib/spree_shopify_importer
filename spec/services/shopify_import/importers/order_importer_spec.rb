require 'spec_helper'

describe ShopifyImport::Importers::OrderImporter, type: :service do
  subject { described_class.new(resource) }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/importers/order_importer' } do
    let(:resource) { ShopifyAPI::Order.find(5_182_437_124).to_json }

    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(5)
    end

    it 'creates spree orders' do
      expect { subject.import! }.to change(Spree::Order, :count).by(1)
    end
  end
end
