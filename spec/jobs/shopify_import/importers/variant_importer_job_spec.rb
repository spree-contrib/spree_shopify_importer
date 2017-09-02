require 'spec_helper'

describe ShopifyImport::Importers::VariantImporterJob, type: :job do
  subject { described_class.new }

  describe '#perfrom' do
    let(:resource) { double('ShopifyAPI::Variant') }
    let(:parent_feed) { double('Shopify::DataFeed') }
    let(:spree_product) { double('Spree::Product') }

    it 'calls a importer service' do
      expect(ShopifyImport::Importers::VariantImporter).to receive(:new).and_call_original
      expect_any_instance_of(ShopifyImport::Importers::VariantImporter).to receive(:import!)

      subject.perform(resource, parent_feed, spree_product)
    end
  end
end
