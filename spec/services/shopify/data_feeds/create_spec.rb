require 'spec_helper'

RSpec.describe Shopify::DataFeeds::Create, type: :service do
  subject { described_class.new(shopify_object) }

  describe 'save!' do
    context 'shopify product' do
      let!(:shopify_object) { create(:shopify_product) }

      it 'creates shopify data feed' do
        expect { subject.save! }.to change(Shopify::DataFeed, :count).by(1)
      end

      context 'saves' do
        let!(:data_feed) { subject.save! }

        it 'shopify object id' do
          expect(data_feed.shopify_object_id).to eq shopify_object.id
        end

        it 'shopify object type' do
          expect(data_feed.shopify_object_type).to eq 'ShopifyAPI::Product'
        end

        it 'shopify object as data feed' do
          expect(data_feed.data_feed).to eq shopify_object.to_json.to_s
        end

        it 'does not assigns parent' do
          expect(data_feed.parent).to be_nil
        end

        context 'with existing parent' do
          let!(:parent) { create(:shopify_data_feed) }

          subject { described_class.new(shopify_object, parent) }

          it 'assigns parent to data feed' do
            expect(data_feed.parent).to eq parent
          end
        end
      end
    end
  end
end
