require 'spec_helper'

describe ShopifyImport::DataParsers::TaxRates::BaseData, type: :service do
  subject { described_class.new(shopify_tax_line, shopify_address) }

  describe '#tax_rate_attributes' do
    let!(:shopify_address) { create(:shopify_address) }
    let!(:shopify_tax_line) { create(:shopify_tax_line) }
    let!(:country) { create(:country, iso: 'US') }
    let!(:zone) { create(:global_zone) }
    let(:tax_category) { Spree::TaxCategory.find_by(name: I18n.t(:shopify)) }
    let(:calculator) { Spree::Calculator::ShopifyTax.last }
    let(:result) do
      {
        name: shopify_tax_line.title,
        amount: shopify_tax_line.rate,
        zone: zone,
        tax_category: tax_category
      }
    end

    it 'returns hash of tax rate attributes' do
      expect(subject.tax_rate_attributes).to eq result
    end

    it 'creates tax category' do
      expect { subject.tax_rate_attributes }.to change(Spree::TaxCategory, :count).by(1)
    end
  end
end
