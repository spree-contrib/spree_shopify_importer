require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::OptionTypes::OptionTypeCreator, type: :service do
  subject { described_class.new(shopify_option) }
  let(:shopify_option) { create(:shopify_single_option) }

  describe '#create!' do
    it 'creates spree option type' do
      expect { subject.create! }.to change(Spree::OptionType, :count).by(1)
    end

    context 'attributes' do
      let(:spree_option_type) { subject.create! }

      it 'name' do
        expect(spree_option_type.name).to eq shopify_option.name.downcase
      end

      it 'presentation' do
        expect(spree_option_type.presentation).to eq shopify_option.name
      end
    end

    context 'associations' do
      it 'option values' do
        expect { subject.create! }.to change(Spree::OptionValue, :count).by(1)
      end

      context 'with multiple values' do
        let(:shopify_option) { create(:shopify_multiple_option, options_count: 3) }

        it 'create multiple values' do
          expect { subject.create! }.to change(Spree::OptionValue, :count).by(3)
        end
      end
    end

    context 'if already created' do
      let!(:option_type) { create(:option_type, name: shopify_option.name) }

      it 'does not create option type' do
        expect { subject.create! }.not_to change(Spree::OptionType, :count)
      end
    end
  end
end
