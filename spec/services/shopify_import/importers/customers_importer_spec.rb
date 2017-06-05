require 'spec_helper'

RSpec.describe ShopifyImport::Importers::CustomersImporter do
  describe '.import!', vcr: { cassette_name: 'shopify_import/importers/customers_importer/import' } do
    before do
      Spree::Config[:shopify_api_key] = 'api_key'
      Spree::Config[:shopify_password] = 'password'
      Spree::Config[:shopify_shop_domain] = 'shop_domain.myshopify.com'
    end

    it 'creates shopify data feeds' do
      expect { described_class.import! }.to change(Shopify::DataFeed, :count).by(1)
    end

    it 'creates spree users' do
      expect { described_class.import! }.to change(Spree.user_class, :count).by(1)
    end
  end
end
