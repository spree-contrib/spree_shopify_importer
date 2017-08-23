require 'spec_helper'

describe ShopifyImport::Importers::OrderImporterJob, type: :job do
  subject { described_class.new }

  describe '#perfrom' do
    let(:resource) { double('ShopifyOrder') }

    it 'calls a importer service' do
      expect(ShopifyImport::Importers::OrderImporter).to receive(:new).and_call_original
      expect_any_instance_of(ShopifyImport::Importers::OrderImporter).to receive(:import!)

      subject.perform(resource)
    end
  end
end
