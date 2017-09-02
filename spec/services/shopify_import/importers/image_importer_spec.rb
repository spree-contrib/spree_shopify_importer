require 'spec_helper'

describe ShopifyImport::Importers::ImageImporter, type: :service do
  let(:valid_src) do
    'https://cdn.shopify.com/s/files/1/2051/3691/'\
    'products/Screenshot_2017-03-03_14.45.16_29b97e8b-f008-460f-8733-b33d551d7140.png?v=1496631699'
  end
  let!(:resource) { create(:shopify_image, sku: 'random-sku', src: valid_src).to_json }
  let!(:parent_feed) { create(:shopify_data_feed) }
  let!(:spree_product) { create(:product) }

  subject { described_class.new(resource, parent_feed, spree_product) }

  describe '#import!', vcr: { cassette_name: 'shopify_import/importers/image_importer' } do
    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(1)
    end

    it 'creates spree variant' do
      expect { subject.import! }.to change(Spree::Image, :count).by(1)
    end
  end
end
