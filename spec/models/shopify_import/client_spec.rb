require 'spec_helper'

RSpec.describe ShopifyImport::Client, type: :model do
  describe '.instance' do
    context 'with valid credentials' do
      let(:credentials) { { api_key: 'foo', password: 'baz', shop_domain: 'test_shop.myshopify.com' } }
      let(:client) { described_class.instance }
      let(:site) { 'https://foo:baz@test_shop.myshopify.com/admin' }

      before { client.get_connection(credentials) }

      it 'creates connection to shopify api' do
        expect(ShopifyAPI::Base.site.to_s).to eq site
      end
    end

    context 'without credentials' do
      let(:client) { described_class.instance }

      context 'with setup config credentials' do
        let(:site) { 'https://api_key:password@shop_domain.myshopify.com/admin' }

        before do
          Spree::Config[:shopify_api_key] = 'api_key'
          Spree::Config[:shopify_password] = 'password'
          Spree::Config[:shopify_shop_domain] = 'shop_domain.myshopify.com'
          client.get_connection
        end

        it 'creates connection to shopify api using preferences' do
          expect(ShopifyAPI::Base.site.to_s).to eq site
        end
      end

      context 'without setup config credentials' do
        it 'raises error' do
          expect { client.get_connection }
            .to raise_error(I18n.t('shopify_import.client.missing_credentials'))
        end
      end
    end

    context 'with auth token' do
      it 'initiates new session as installed app' do
        allow(ShopifyAPI::Session).to receive(:new)
        shop_domain = 'awesomeness.myshopify.com'
        token = 'auth_token'

        ShopifyImport::Client.instance.get_connection(shop_domain: shop_domain, token: token)

        expect(ShopifyAPI::Session).to have_received(:new).with(shop_domain, token)
      end
    end

    context 'with invalid credentials'
  end
end
