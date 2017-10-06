require 'spec_helper'

describe ShopifyImport::DataSavers::Promotions::PromotionCreator, type: :service do
  let(:spree_order) { create(:order) }
  let(:shopify_discount_code) { create(:shopify_discount_code) }
  subject { described_class.new(spree_order, shopify_discount_code) }

  describe '#create!!' do
    it 'creates promotion' do
      expect { subject.create! }.to change(Spree::Promotion, :count).by(1)
    end

    context 'sets attributes' do
      let(:promotion) { Spree::Promotion.last }

      before { subject.create! }

      it 'name' do
        expect(promotion.name).to eq shopify_discount_code.code.downcase
      end

      it 'code' do
        expect(promotion.code).to eq shopify_discount_code.code.downcase
      end

      it 'expires_at' do
        expect(promotion.expires_at).to be_within(1).of(Time.current)
      end
    end
  end
end
