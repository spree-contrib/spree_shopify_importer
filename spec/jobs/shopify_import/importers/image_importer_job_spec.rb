require 'spec_helper'

describe ShopifyImport::Importers::ImageImporterJob, type: :job do
  subject { described_class.new }

  describe '#perfrom' do
    let(:resource) { double('ShopifyAPI::Image') }
    let(:parent_feed) { double('Shopify::DataFeed') }
    let(:spree_object) { double('Spree::Product') }

    it 'calls a importer service' do
      expect(ShopifyImport::Importers::ImageImporter).to receive(:new).and_call_original
      expect_any_instance_of(ShopifyImport::Importers::ImageImporter).to receive(:import!)

      subject.perform(resource, parent_feed, spree_object)
    end
  end
end
