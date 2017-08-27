require 'spec_helper'

describe ShopifyImport::DataParsers::Adjustments::Promotions::BaseData, type: :service do
  let(:spree_order) { create(:order) }
  let(:spree_promotion) { create(:promotion) }
  let(:shopify_discount_code) { create(:shopify_discount_code) }
  subject { described_class.new(spree_order, spree_promotion, shopify_discount_code) }

  describe '#attributes' do
    let(:action) { Spree::Promotion::Actions::CreateAdjustment.last }
    let(:result) do
      {
        source: action,
        order: spree_order,
        amount: - shopify_discount_code.amount.to_d,
        state: :closed,
        label: shopify_discount_code.code,
        adjustable: spree_order
      }
    end

    it 'creates spree promotion action' do
      expect { subject.attributes }.to change(Spree::Promotion::Actions::CreateAdjustment, :count).by(1)
    end

    it 'returns hash of spree adjustment attributes' do
      expect(subject.attributes).to eq result
    end
  end

  describe '#timestamps' do
    let(:result) do
      {
        created_at: spree_order.created_at,
        updated_at: spree_order.updated_at
      }
    end

    it 'returns hash of spree adjustment timestamps' do
      expect(subject.timestamps).to eq result
    end
  end
end
