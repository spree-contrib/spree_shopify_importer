require 'spec_helper'

describe ShopifyImport::DataSavers::OptionValues::OptionValueCreator, type: :service do
  subject { described_class.new(shopify_value, spree_option_type) }
  let(:shopify_value) { 'Amethyst' }
  let(:spree_option_type) { create(:option_type) }

  describe '#create!' do
    it 'creates option value' do
      expect { subject.create! }.to change(Spree::OptionValue, :count).by(1)
    end

    context 'attributes' do
      let(:spree_option_value) { subject.create! }

      it 'name' do
        expect(spree_option_value.name).to eq shopify_value.downcase
      end

      it 'presentation' do
        expect(spree_option_value.presentation).to eq shopify_value
      end
    end

    context 'associations' do
      let(:spree_option_value) { subject.create! }

      it 'option type' do
        expect(spree_option_value.option_type).to eq spree_option_type
      end
    end

    context 'if already created' do
      let!(:spree_option_value) { create(:option_value, name: shopify_value, option_type: spree_option_type) }

      it 'does not create option value' do
        expect { subject.create! }.not_to change(Spree::OptionValue, :count)
      end
    end
  end
end
