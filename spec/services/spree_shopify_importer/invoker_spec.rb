require 'spec_helper'

RSpec.describe SpreeShopifyImporter::Invoker do
  describe '#import!' do
    before do
      allow(SpreeShopifyImporter::Connections::Client.instance).to receive(:get_connection)
      SpreeShopifyImporter::Invoker::ROOT_FETCHERS.each do |importer|
        allow_any_instance_of(importer).to receive(:import!)
      end
    end

    context 'with credentials parameter' do
      let(:credentials) do
        {
          api_key: 'api_key', password: 'password',
          shop_domain: 'spree-shopify-importer-test-store.myshopify.com'
        }
      end

      it 'gets the connection from the client' do
        SpreeShopifyImporter::Invoker.new(credentials: credentials).import!

        expect(SpreeShopifyImporter::Connections::Client.instance).to have_received(:get_connection).with(credentials)
      end

      it 'calls all the importers' do
        aggregate_failures 'testing each importer' do
          SpreeShopifyImporter::Invoker::ROOT_FETCHERS.each do |importer|
            expect_any_instance_of(importer).to receive(:import!)
          end
        end

        SpreeShopifyImporter::Invoker.new(credentials: credentials).import!
      end

      it 'sets current credentials' do
        SpreeShopifyImporter::Invoker.new(credentials: credentials).import!

        expect(Spree::Config[:shopify_current_credentials]).to eq credentials
      end
    end

    context 'with config credentials' do
      before do
        Spree::Config[:shopify_api_key] = 'api_key'
        Spree::Config[:shopify_password] = 'password'
        Spree::Config[:shopify_shop_domain] = 'spree-shopify-importer-test-store.myshopify.com'
      end

      it 'creates connection to Shopify API using preferences' do
        SpreeShopifyImporter::Invoker.new.import!

        expect(SpreeShopifyImporter::Connections::Client.instance).to have_received(:get_connection).with(
          api_key: Spree::Config[:shopify_api_key],
          password: Spree::Config[:shopify_password],
          shop_domain: Spree::Config[:shopify_shop_domain],
          token: nil
        )
      end
    end
  end
end
