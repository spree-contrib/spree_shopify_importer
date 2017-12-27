require 'spec_helper'

describe ShopifyImport::DataParsers::OptionTypes::BaseData, type: :service do
  subject { described_class.new(option_type) }
  let(:option_type) { create(:shopify_base_option) }

  describe '#name' do
    it 'returns option type name' do
      expect(subject.name).to eq option_type.name.downcase
    end
  end

  describe '#attributes' do
    let(:result) do
      {
        name: option_type.name.downcase,
        presentation: option_type.name
      }
    end

    it 'return hash of option type attributes' do
      expect(subject.attributes).to eq result
    end
  end

  describe '#shopify_values' do
    let(:option_type) { create(:shopify_base_option, values: ['Amethyst', 'Opal', nil]) }

    it 'return array of values' do
      expect(subject.shopify_values).to eq %w[Amethyst Opal]
    end
  end
end
