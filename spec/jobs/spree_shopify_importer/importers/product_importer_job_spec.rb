require 'spec_helper'

describe SpreeShopifyImporter::Importers::ProductImporterJob, type: :job do
  subject { described_class.new }

  describe '#perfrom' do
    let(:resource) { double('ShopifyProduct') }

    it 'calls a importer service' do
      expect(SpreeShopifyImporter::Importers::ProductImporter).to receive(:new).and_call_original
      expect_any_instance_of(SpreeShopifyImporter::Importers::ProductImporter).to receive(:import!)

      subject.perform(resource)
    end
  end
end
