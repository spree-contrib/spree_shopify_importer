require 'spec_helper'

describe Spree::Calculator::Shipping::Shopify, type: :model do
  describe '.description' do
    it 'returns a proper description' do
      expect(described_class.description).to eq I18n.t(:shopify)
    end
  end

  describe 'default preferences' do
    subject { described_class.new }

    it 'amount' do
      expect(subject.preferences[:amount]).to eq 0
    end

    it 'currency' do
      expect(subject.preferences[:currency]).to eq Spree::Config[:currency]
    end
  end

  describe '#compute_package' do
    let(:variant1) { build(:variant, price: 10.11) }
    let(:variant2) { build(:variant, price: 20.2222) }

    let(:line_item1) { build(:line_item, variant: variant1) }
    let(:line_item2) { build(:line_item, variant: variant2) }

    let(:package) { build(:stock_package, variants_contents: { variant1 => 2, variant2 => 1 }) }

    subject { described_class.new }

    it 'should round result correctly' do
      expect(subject.compute(package)).to eq(package.order.shipment_total)
    end
  end
end
