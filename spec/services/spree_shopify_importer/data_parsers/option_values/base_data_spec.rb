require 'spec_helper'

describe SpreeShopifyImporter::DataParsers::OptionValues::BaseData, type: :service do
  subject { described_class.new(value) }
  let(:value) { 'Amethyst' }

  describe '#name' do
    it 'return value name' do
      expect(subject.name).to eq value.downcase
    end
  end

  describe '#attribtues' do
    let(:result) do
      {
        name: value.downcase,
        presentation: value
      }
    end

    it 'return hash of value attributes' do
      expect(subject.attributes).to eq result
    end
  end
end
