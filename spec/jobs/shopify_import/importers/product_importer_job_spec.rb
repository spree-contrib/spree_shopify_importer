require 'spec_helper'

describe ShopifyImport::Importers::ProductImporterJob, type: :job do
  subject { described_class.new }

  describe '#perfrom' do
    let(:resource) { double('ShopifyProduct') }

    it 'calls a importer service' do
      expect(ShopifyImport::Importers::ProductImporter).to receive(:new).and_call_original
      expect_any_instance_of(ShopifyImport::Importers::ProductImporter).to receive(:import!)

      subject.perform(resource)
    end
  end
end
