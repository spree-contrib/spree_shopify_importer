require 'spec_helper'

describe SpreeShopifyImporter::Importers::ReturnAuthorizationImporter, type: :service do
  let!(:parent_feed) { create(:shopify_data_feed) }
  let!(:spree_order) { create(:order) }
  subject { described_class.new(shopify_refund, parent_feed, spree_order) }

  before { authenticate_with_shopify }

  describe '#import!' do
    context 'with basic return authorization data', vcr: { cassette_name: 'shopify/order_with_refund' } do
      let(:shopify_refund) { ShopifyAPI::Order.find(5_182_437_124).refunds.first }

      it 'creates shopify data feeds' do
        expect { subject.import! }.to change(SpreeShopifyImporter::DataFeed, :count).by(1)
      end

      it 'creates spree return authorization' do
        expect { subject.import! }.to change(Spree::ReturnAuthorization, :count).by(1)
      end

      context 'with existing data feed' do
        let!(:shopify_data_feed) do
          create(:shopify_data_feed,
                 shopify_object_id: shopify_refund.id,
                 shopify_object_type: 'ShopifyAPI::Refund',
                 data_feed: shopify_refund.to_json)
        end

        it 'does not create shopify data feeds' do
          expect { subject.import! }.not_to change(SpreeShopifyImporter::DataFeed, :count)
        end

        it 'creates spree return authorization' do
          expect { subject.import! }.to change(Spree::ReturnAuthorization, :count).by(1)
        end
      end
    end
  end
end
