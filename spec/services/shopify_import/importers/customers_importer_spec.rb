require 'spec_helper'

RSpec.describe ShopifyImport::Importers::CustomersImporter do
  describe '#import!', vcr: { cassette_name: 'shopify_import/customers_importer/import' } do
    before { authenticate_with_shopify }

    it 'creates shopify data feeds' do
      expect { described_class.new.import! }.to change(Shopify::DataFeed, :count).by(2)
    end

    it 'creates spree users' do
      expect { described_class.new.import! }.to change(Spree.user_class, :count).by(2)
    end
  end
end
