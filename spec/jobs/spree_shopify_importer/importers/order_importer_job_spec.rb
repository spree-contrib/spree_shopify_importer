require 'spec_helper'

describe SpreeShopifyImporter::Importers::OrderImporterJob, type: :job do
  subject { described_class.new }

  describe '#perfrom' do
    let(:resource) { double('ShopifyOrder') }

    it 'calls a importer service' do
      expect(SpreeShopifyImporter::Importers::OrderImporter).to receive(:new).and_call_original
      expect_any_instance_of(SpreeShopifyImporter::Importers::OrderImporter).to receive(:import!)

      subject.perform(resource)
    end
  end
end
