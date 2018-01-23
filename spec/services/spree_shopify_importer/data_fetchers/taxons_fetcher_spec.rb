require 'spec_helper'

RSpec.describe SpreeShopifyImporter::DataFetchers::TaxonsFetcher, type: :service do
  subject { described_class.new }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/custom_collections_importer/import' } do
    it 'enqueue a job' do
      expect { subject.import! }.to have_enqueued_job(SpreeShopifyImporter::Importers::TaxonImporterJob).twice
    end
  end
end
