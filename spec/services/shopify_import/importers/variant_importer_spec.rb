require 'spec_helper'

describe ShopifyImport::Importers::VariantImporter, type: :service do
  let!(:option_value) { create(:option_value) }
  let!(:parent_feed) { create(:shopify_data_feed) }
  let!(:spree_product) { create(:product) }

  let(:shopify_image) { create(:shopify_image).to_json }
  let(:resource) { create(:shopify_variant, sku: 'random-sku').to_json }

  subject { described_class.new(resource, parent_feed, spree_product, shopify_image) }

  before do
    allow_any_instance_of(ShopifyImport::DataParsers::Variants::BaseData)
      .to receive(:option_value_ids).and_return([option_value.id])
  end

  describe '#import!' do
    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(1)
    end

    it 'creates spree variant' do
      expect { subject.import! }.to change(Spree::Variant, :count).by(1)
    end

    it 'enqueue a image importer job' do
      expect { subject.import! }.to enqueue_job(ShopifyImport::Importers::ImageImporterJob).once
    end
  end
end
