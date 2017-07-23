require 'spec_helper'

RSpec.describe ShopifyImport::Importers::TaxonImporter, type: :service do
  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/custom_collections_importer/import' } do
    it 'creates shopify data feeds' do
      expect { described_class.new.import! }.to change(Shopify::DataFeed, :count).by(2)
    end

    it 'creates spree taxonomy' do
      expect { described_class.new.import! }.to change(Spree::Taxonomy, :count).by(1)
    end

    it 'creates spree taxons' do
      # One of taxons is taxonomy root.
      expect { described_class.new.import! }.to change(Spree::Taxon, :count).by(3)
    end
  end
end
