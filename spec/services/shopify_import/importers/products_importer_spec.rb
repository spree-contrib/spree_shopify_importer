require 'spec_helper'

RSpec.describe ShopifyImport::Importers::ProductsImporter, type: :service do
  describe '.import!', :vcr do
    context 'with params' do
      let(:credentials) { { api_key: 'api_key', password: 'password', shop_name: 'shop_domain' } }
      let(:params) { { credentials: credentials, created_at_min: '2017-04-22T15:00:00+02:00' } }

      it 'creates shopify data feeds' do
        expect { described_class.import!(params) }.to change(Shopify::DataFeed, :count).by(1)
      end

      it 'creates spree products' do
        expect { described_class.import!(params) }.to change(Spree::Product, :count).by(1)
      end
    end

    context 'without params' do
      before do
        Spree::Config[:shopify_api_key] = 'api_key'
        Spree::Config[:shopify_password] = 'password'
        Spree::Config[:shopify_shop_domain] = 'shop_domain'
      end

      it 'creates shopify data feeds' do
        expect { described_class.import! }.to change(Shopify::DataFeed, :count).by(2)
      end

      it 'creates spree products' do
        expect { described_class.import! }.to change(Spree::Product, :count).by(2)
      end
    end
  end
end
