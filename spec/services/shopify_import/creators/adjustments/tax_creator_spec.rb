require 'spec_helper'

describe ShopifyImport::Creators::Adjustments::TaxCreator, type: :service do
  subject { described_class.new(shopify_tax_line, spree_order, spree_tax_rate) }

  describe '#save!' do
    let(:spree_order) { create(:order) }
    let(:spree_tax_rate) { create(:tax_rate) }
    let(:shopify_tax_line) { create(:shopify_tax_line) }

    it 'creates tax adjustment' do
      expect { subject.save! }.to change(Spree::Adjustment, :count).by(1)
    end

    context 'sets an adjustment attributes' do
      let(:adjustment) { Spree::Adjustment.last }

      before { subject.save! }

      it 'label' do
        expect(adjustment.label).to eq shopify_tax_line.title
      end

      it 'amount' do
        expect(adjustment.amount).to eq shopify_tax_line.price
      end

      it 'state' do
        expect(adjustment).to be_closed
      end
    end

    context 'sets an adjustment associations' do
      let(:adjustment) { Spree::Adjustment.last }

      before { subject.save! }

      it 'order' do
        expect(adjustment.order).to eq spree_order
      end

      it 'adjustable' do
        expect(adjustment.adjustable).to eq spree_order
      end

      it 'source' do
        expect(adjustment.source).to eq spree_tax_rate
      end
    end
  end
end
