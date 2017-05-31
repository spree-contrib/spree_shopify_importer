require 'spec_helper'

RSpec.describe ShopifyImport::Invoker do
  describe '#import!' do
    let(:credentials) { { api_key: 'key', password: 'pass', shop_domain: 'domain.myshopify.com' } }

    it 'gets the connection from the client' do
      allow(ShopifyImport::Client.instance).to receive(:get_connection)
      allow_any_instance_of(ShopifyImport::Importers::ProductsImporter).to receive(:import!)

      ShopifyImport::Invoker.new(credentials: credentials).import!

      expect(ShopifyImport::Client.instance).to have_received(:get_connection).with(credentials)
    end

    it 'calls all the importers' do
      products_importer = double('products_importer', import!: '')
      allow(ShopifyImport::Importers::ProductsImporter).to receive(:new).and_return(products_importer)

      ShopifyImport::Invoker.new(credentials: credentials).import!

      expect(products_importer).to have_received(:import!)
    end
  end
end
