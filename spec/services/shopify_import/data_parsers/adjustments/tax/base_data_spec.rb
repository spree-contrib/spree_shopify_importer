require 'spec_helper'

describe ShopifyImport::DataParsers::Adjustments::Tax::BaseData, type: :service do
  subject { described_class.new(shopify_tax_line, spree_order, spree_tax_rate) }

  describe '#adjustment_attributes' do
    let(:spree_order) { create(:order) }
    let(:spree_tax_rate) { create(:tax_rate) }
    let(:shopify_tax_line) { create(:shopify_tax_line) }
    let(:result) do
      {
        order: spree_order,
        adjustable: spree_order,
        label: shopify_tax_line.title,
        source: spree_tax_rate,
        amount: shopify_tax_line.price,
        state: :closed
      }
    end

    it 'returns hash of tax adjustment attributes' do
      expect(subject.adjustment_attributes).to eq result
    end
  end
end
