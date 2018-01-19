require 'spec_helper'

describe SpreeShopifyImporter::Importers::VariantImporter, type: :service do
  let!(:option_value) { create(:option_value) }
  let!(:parent_feed) { create(:shopify_data_feed) }
  let!(:spree_product) { create(:product) }

  let(:shopify_image) { create(:shopify_image).to_json }
  let(:shopify_variant) { create(:shopify_variant, sku: 'random-sku') }
  let(:resource) { shopify_variant.to_json }

  subject { described_class.new(resource, parent_feed, spree_product, shopify_image) }

  before do
    allow_any_instance_of(SpreeShopifyImporter::DataParsers::Variants::BaseData)
      .to receive(:option_value_ids).and_return([option_value.id])
  end

  describe '#import!' do
    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(SpreeShopifyImporter::DataFeed, :count).by(1)
    end

    it 'creates spree variant' do
      expect { subject.import! }.to change(Spree::Variant, :count).by(1)
    end

    it 'enqueue a image importer job' do
      expect { subject.import! }.to enqueue_job(SpreeShopifyImporter::Importers::ImageImporterJob).once
    end

    context 'with existing data feed' do
      let!(:shopify_data_feed) do
        create(:shopify_data_feed,
               shopify_object_id: shopify_variant.id,
               shopify_object_type: 'ShopifyAPI::Variant',
               data_feed: resource, spree_object: nil)
      end

      it 'does not create shopify data feeds' do
        expect { subject.import! }.not_to change(SpreeShopifyImporter::DataFeed, :count)
      end

      it 'creates spree variant' do
        expect { subject.import! }.to change(Spree::Variant, :count).by(1)
      end

      it 'enqueue a image importer job' do
        expect { subject.import! }.to enqueue_job(SpreeShopifyImporter::Importers::ImageImporterJob).once
      end

      context 'and variant' do
        let!(:shopify_data_feed) do
          create(:shopify_data_feed,
                 shopify_object_id: shopify_variant.id,
                 shopify_object_type: 'ShopifyAPI::Variant',
                 data_feed: resource, spree_object: create(:variant, product: spree_product))
        end

        it 'does not create shopify data feeds' do
          expect { subject.import! }.not_to change(SpreeShopifyImporter::DataFeed, :count)
        end

        it 'creates spree variant' do
          expect { subject.import! }.not_to change(Spree::Variant, :count)
        end

        it 'enqueue a image importer job' do
          expect { subject.import! }.to enqueue_job(SpreeShopifyImporter::Importers::ImageImporterJob).once
        end
      end
    end
  end
end
