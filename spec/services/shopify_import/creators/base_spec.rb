require 'spec_helper'

RSpec.describe ShopifyImport::Creators::Base, type: :service do
  let(:shopify_data_feed) { create(:shopify_data_feed) }
  subject { described_class.new(shopify_data_feed) }

  describe '#save!' do
    it 'raises not implemented error' do
      expect { subject.save! }.to raise_error NotImplementedError
    end
  end
end
