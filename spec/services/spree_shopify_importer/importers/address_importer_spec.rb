require 'spec_helper'

describe SpreeShopifyImporter::Importers::AddressImporter, type: :service do
  subject { described_class.new(resource, spree_user) }

  before { authenticate_with_shopify }

  describe '#import!' do
    let(:shopify_address) { create(:shopify_address) }
    let(:resource) { shopify_address.to_json }
    let(:spree_user) { create(:user) }

    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(SpreeShopifyImporter::DataFeed, :count).by(1)
    end

    it 'creates spree address' do
      expect { subject.import! }.to change(Spree::Address, :count).by(1)
    end

    context 'with existing data feed' do
      let!(:shopify_data_feed) do
        create(:shopify_data_feed,
               shopify_object_id: shopify_address.id,
               shopify_object_type: 'ShopifyAPI::Address',
               data_feed: resource, spree_object: nil)
      end

      it 'does not create shopify data feeds' do
        expect { subject.import! }.not_to change(SpreeShopifyImporter::DataFeed, :count)
      end

      it 'creates spree address' do
        expect { subject.import! }.to change(Spree::Address, :count).by(1)
      end

      context 'and address' do
        let!(:shopify_data_feed) do
          create(:shopify_data_feed,
                 shopify_object_id: shopify_address.id,
                 shopify_object_type: 'ShopifyAPI::Address',
                 data_feed: resource,
                 spree_object: create(:address))
        end

        it 'does not create shopify data feeds' do
          expect { subject.import! }.not_to change(SpreeShopifyImporter::DataFeed, :count)
        end

        it 'does not create spree address' do
          expect { subject.import! }.not_to change(Spree::Address, :count)
        end
      end
    end
  end
end
