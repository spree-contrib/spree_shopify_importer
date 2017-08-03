require 'spec_helper'

describe ShopifyImport::Creators::TaxRateCreator, type: :service do
  let!(:country) { create(:country, iso: 'US') }
  let!(:zone) { create(:global_zone) }
  subject { described_class.new(shopify_tax_line, shopify_address) }

  before { authenticate_with_shopify }

  describe '#create!' do
    let!(:shopify_address) { create(:shopify_address) }
    let!(:shopify_tax_line) { create(:shopify_tax_line) }

    it 'creates tax rate' do
      expect { subject.create! }.to change(Spree::TaxRate, :count).by(1)
    end

    it 'creates shopify tax calculator' do
      expect { subject.create! }.to change(Spree::Calculator::ShopifyTax, :count).by(1)
    end

    context 'sets a tax rate attributes' do
      let(:tax_rate) { subject.create! }

      it 'name' do
        expect(tax_rate.name).to eq shopify_tax_line.title
      end

      it 'amount' do
        expect(tax_rate.amount).to eq shopify_tax_line.rate
      end
    end

    context 'sets a tax rate associations' do
      let(:tax_rate) { subject.create! }
      let(:tax_category) { Spree::TaxCategory.last }
      let(:calculator) { Spree::Calculator::ShopifyTax.last }

      it 'zone' do
        expect(tax_rate.zone).to eq zone
      end

      it 'tax category' do
        expect(tax_rate.tax_category).to eq tax_category
      end

      it 'calculator' do
        expect(tax_rate.calculator).to eq calculator
      end
    end
  end
end
