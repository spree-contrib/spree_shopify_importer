require 'spec_helper'

describe SpreeShopifyImporter::Importers::TaxonImporterJob, type: :job do
  subject { described_class.new }

  describe '#perfrom' do
    let(:resource) { double('ShopifyCustomCollection') }

    it 'calls a importer service' do
      expect(SpreeShopifyImporter::Importers::TaxonImporter).to receive(:new).and_call_original
      expect_any_instance_of(SpreeShopifyImporter::Importers::TaxonImporter).to receive(:import!)

      subject.perform(resource)
    end
  end
end
