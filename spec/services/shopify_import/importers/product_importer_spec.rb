require 'spec_helper'

describe ShopifyImport::Importers::ProductImporter, type: :service do
  subject { described_class.new(resource) }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/importers/product_importer' } do
    let(:resource) { ShopifyAPI::Product.find(11_101_525_828).to_json }

    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(2)
    end

    it 'creates spree products' do
      expect { subject.import! }.to change(Spree::Product, :count).by(1)
    end

    it 'creates spree variants' do
      expect { subject.import! }.to change(Spree::Variant, :count).by(2)
    end
  end
end
