require 'spec_helper'

describe ShopifyImport::DataParsers::Promotions::BaseData, type: :service do
  let!(:shopify_discount_code) { create(:shopify_discount_code) }
  subject { described_class.new(shopify_discount_code) }

  describe '#promotion_attributes' do
    let(:result) do
      {
        name: shopify_discount_code.code.downcase,
        code: shopify_discount_code.code.downcase
      }
    end

    it 'return hash of promotion attributes' do
      expect(subject.promotion_attributes).to eq result
    end
  end

  describe '#expires_at' do
    it 'return current time' do
      expect(subject.expires_at).to be_within(1).of(Time.current)
    end
  end
end
