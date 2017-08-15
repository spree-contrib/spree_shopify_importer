require 'spec_helper'

describe ShopifyImport::Importers::TaxonImporter, type: :service do
  subject { described_class.new(resource) }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/importers/taxon_importer/import' } do
    let(:resource) { ShopifyAPI::CustomCollection.find(:first).to_json }

    it 'creates shopify data feeds' do
      expect { subject.import! }.to change(Shopify::DataFeed, :count).by(1)
    end

    it 'creates spree taxonomy' do
      expect { subject.import! }.to change(Spree::Taxonomy, :count).by(1)
    end

    it 'creates spree taxons' do
      # One of taxons is taxonomy root.
      expect { subject.import! }.to change(Spree::Taxon, :count).by(2)
    end
  end
end
