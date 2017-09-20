require 'spec_helper'

describe Shopify::DataFeeds::Update, type: :service do
  subject { described_class.new(shopify_data_feed, shopify_object) }

  describe '#update!' do
    let(:shopify_data_feed) { create(:shopify_data_feed, data_feed: nil) }
    let(:shopify_object) { create(:shopify_product) }

    before { subject.update! }

    it 'updates shopify data feed data' do
      expect(shopify_data_feed.data_feed).to eq shopify_object.to_json
    end

    describe 'with parent' do
      let(:parent) { create(:shopify_data_feed) }
      subject { described_class.new(shopify_data_feed, shopify_object, parent) }

      it 'sets parent to data feed' do
        expect(shopify_data_feed.parent).to eq parent
      end
    end
  end
end
