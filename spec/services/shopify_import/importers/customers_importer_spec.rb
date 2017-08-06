require 'spec_helper'

RSpec.describe ShopifyImport::Importers::UserImporter do
  describe '#import!', vcr: { cassette_name: 'shopify_import/customers_importer/import' } do
    before { authenticate_with_shopify }

    it 'creates shopify data feeds' do
      expect { described_class.new.import! }.to change(Shopify::DataFeed, :count).by(4)
    end

    it 'creates spree users' do
      expect { described_class.new.import! }.to change(Spree.user_class, :count).by(2)
    end
  end
end
