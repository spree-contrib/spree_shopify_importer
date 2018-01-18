require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::Adjustments::PromotionCreator, type: :service do
  let(:spree_order) { create(:order) }
  let(:spree_promotion) { create(:promotion) }
  let(:shopify_discount_code) { create(:shopify_discount_code) }
  subject { described_class.new(spree_order, spree_promotion, shopify_discount_code) }

  describe '#create!' do
    it 'creates spree adjustment' do
      expect { subject.create! }.to change(Spree::Adjustment, :count).by(1)
    end

    context 'sets attributes' do
      let(:adjustment) { Spree::Adjustment.last }

      before { subject.create! }

      it 'amount' do
        expect(adjustment.amount).to eq(- shopify_discount_code.amount.to_d)
      end

      it 'state' do
        expect(adjustment.state).to eq 'closed'
      end

      it 'label' do
        expect(adjustment.label).to eq shopify_discount_code.code
      end

      it 'created_at' do
        expect(adjustment.created_at).to be_within(1).of(spree_order.created_at)
      end

      it 'updated_at' do
        expect(adjustment.updated_at).to be_within(1).of(spree_order.created_at)
      end
    end

    context 'assigns associations' do
      let(:adjustment) { Spree::Adjustment.last }
      let(:source) { Spree::Promotion::Actions::CreateAdjustment.last }

      before { subject.create! }

      it 'source' do
        expect(adjustment.source).to eq source
      end

      it 'order' do
        expect(adjustment.order).to eq spree_order
      end

      it 'adjustable' do
        expect(adjustment.adjustable).to eq spree_order
      end
    end
  end
end
