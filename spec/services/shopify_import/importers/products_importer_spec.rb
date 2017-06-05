require 'spec_helper'

RSpec.describe ShopifyImport::Importers::ProductsImporter, type: :service do
  describe '#import!' do
    before { authenticate_with_shopify }

    context 'with params', vcr: { cassette_name: 'shopify_import/products_importer/import_with_params' } do
      let(:params) { { created_at_min: '2017-04-22T15:00:00+02:00' } }

      it 'creates shopify data feeds' do
        expect { described_class.new(params).import! }.to change(Shopify::DataFeed, :count).by(1)
      end

      it 'creates spree products' do
        expect { described_class.new(params).import! }.to change(Spree::Product, :count).by(1)
      end
    end

    context 'without params', vcr: { cassette_name: 'shopify_import/products_importer/import' } do
      it 'creates shopify data feeds' do
        expect { described_class.new.import! }.to change(Shopify::DataFeed, :count).by(2)
      end

      it 'creates spree products' do
        expect { described_class.new.import! }.to change(Spree::Product, :count).by(2)
      end
    end
  end
end
