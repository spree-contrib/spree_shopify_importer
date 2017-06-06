require 'spec_helper'

RSpec.describe ShopifyImport::Client, type: :model do
  describe '#get_connection' do
    let(:client) { described_class.instance }

    after { ShopifyAPI::Base.clear_session }

    context 'with api_key and password' do
      let(:credentials) do
        {
          api_key: '0a9445b7b067719a0af024610364ee34', password: '800f97d6ea1a768048851cdd99a9101a',
          shop_domain: 'spree-shopify-importer-test-store.myshopify.com'
        }
      end

      context 'valid credentials', vcr: { cassette_name: 'client/valid_api_key_and_password' } do
        it 'creates connection to Shopify API' do
          expect(client.get_connection(credentials)).to be_persisted
        end
      end

      context 'invalid credentials' do
        context 'invalid api_key', vcr: { cassette_name: 'client/invalid_api_key_and_valid_password' } do
          let(:invalid_api_key_credentials) { credentials.merge(api_key: 'invalid_key') }

          it 'raises ForbiddenAccess error' do
            expect { client.get_connection(invalid_api_key_credentials) }
              .to raise_error(ActiveResource::ForbiddenAccess)
          end
        end

        context 'invalid password', vcr: { cassette_name: 'client/valid_api_key_and_invalid_password' } do
          let(:invalid_password_credentials) { credentials.merge(password: 'invalid_password') }

          it 'raises UnauthorizedAccess error' do
            expect { client.get_connection(invalid_password_credentials) }
              .to raise_error(ActiveResource::UnauthorizedAccess)
          end
        end
      end

      context 'invalid shop_domain', vcr: { cassette_name: 'client/valid_api_key_and_password_invalid_shop_domain' } do
        let(:invalid_shop_domain_credentials) { credentials.merge(shop_domain: 'example.myshopify.com') }

        it 'raises UnauthorizedAccess error' do
          expect { client.get_connection(invalid_shop_domain_credentials) }
            .to raise_error(ActiveResource::UnauthorizedAccess)
        end
      end
    end

    context 'with auth token' do
      let(:credentials) do
        { shop_domain: 'spree-shopify-importer-test-store.myshopify.com', token: '918b6723f062d8805b364dba757782c5' }
      end

      context 'valid credentials', vcr: { cassette_name: 'client/valid_auth_token' } do
        it 'initiates new session as installed app' do
          expect(client.get_connection(credentials)).to be_persisted
        end
      end

      context 'invalid auth token', vcr: { cassette_name: 'client/invalid_auth_token' } do
        let(:invalid_auth_token_credentials) { credentials.merge(token: 'invalid_token') }

        it 'raises UnauthorizedAccess error' do
          expect { client.get_connection(invalid_auth_token_credentials) }
            .to raise_error(ActiveResource::UnauthorizedAccess)
        end
      end

      context 'invalid shop_domain', vcr: { cassette_name: 'client/valid_auth_token_invalid_shop_domain' } do
        let(:invalid_shop_domain_credentials) { credentials.merge(shop_domain: 'example.myshopify.com') }

        it 'raises UnauthorizedAccess error' do
          expect { client.get_connection(invalid_shop_domain_credentials) }
            .to raise_error(ActiveResource::UnauthorizedAccess)
        end
      end
    end

    context 'without credentials' do
      it 'raises ShopifyImporter::ClientError error' do
        credentials = { shop_domain: 'spree-shopify-importer-test-store.myshopify.com' }

        expect { client.get_connection(credentials) }
          .to raise_error(ShopifyImport::ClientError, I18n.t('shopify_import.client.missing_credentials'))
      end
    end
  end
end
