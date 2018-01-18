require 'spec_helper'

describe SpreeShopifyImporter::Importers::VariantImporterJob, type: :job do
  subject { described_class.new }

  describe '#perfrom' do
    let(:resource) { double('ShopifyAPI::Variant') }
    let(:parent_feed) { double('Shopify::DataFeed') }
    let(:spree_product) { double('Spree::Product') }

    it 'calls a importer service' do
      expect(SpreeShopifyImporter::Importers::VariantImporter).to receive(:new).and_call_original
      expect_any_instance_of(SpreeShopifyImporter::Importers::VariantImporter).to receive(:import!)

      subject.perform(resource, parent_feed, spree_product)
    end

    context 'with image data' do
      let(:shopify_image) { double('ShopifyAPI::Image') }

      it 'calls a importer service' do
        expect(SpreeShopifyImporter::Importers::VariantImporter).to receive(:new).and_call_original
        expect_any_instance_of(SpreeShopifyImporter::Importers::VariantImporter).to receive(:import!)

        subject.perform(resource, parent_feed, spree_product, shopify_image)
      end
    end
  end
end
