require 'spec_helper'

RSpec.describe ShopifyImport::Base, type: :model do
  subject { described_class }

  describe '.new' do
    context 'with credentials' do
      let(:credentials) { { api_key: 'foo', password: 'bar', shop_domain: 'baz.myshopify.com' } }

      it 'calls singleton for client with params' do
        expect_any_instance_of(ShopifyImport::Client).to receive(:get_connection).with(credentials)
        subject.new(credentials: credentials)
      end
    end

    context 'without credentials' do
      it 'calls singleton for client with default values' do
        expect_any_instance_of(ShopifyImport::Client).to receive(:get_connection).with({})
        subject.new
      end
    end

    context 'with client' do
      let!(:client) { instance_double('ShopifyImport::Client') }

      it 'does not creates new connection' do
        expect_any_instance_of(ShopifyImport::Client).not_to receive(:get_connection)
        subject.new(client: client)
      end
    end
  end

  describe '#count', :vcr do
    let(:credentials) { { credentials: { api_key: 'foo', password: 'bar', shop_domain: 'shop_name.myshopify.com' } } }

    it 'raises error ActiveResource::ResourceNotFound' do
      expect { subject.new(credentials).count }.to raise_error ActiveResource::ResourceNotFound
    end
  end
end
