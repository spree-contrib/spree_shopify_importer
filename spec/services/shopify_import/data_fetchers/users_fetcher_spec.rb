require 'spec_helper'

RSpec.describe ShopifyImport::DataFetchers::UsersFetcher do
  subject { described_class.new }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/customers_importer/import' } do
    it 'enqueue a taxon importer job' do
      expect { subject.import! }.to have_enqueued_job(ShopifyImport::Importers::UserImporterJob).twice
    end
  end
end
