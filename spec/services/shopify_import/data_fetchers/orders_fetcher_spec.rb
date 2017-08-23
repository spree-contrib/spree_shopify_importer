require 'spec_helper'

RSpec.describe ShopifyImport::DataFetchers::OrdersFetcher, type: :service do
  subject { described_class.new }

  before { authenticate_with_shopify }

  describe '#import!', vcr: { cassette_name: 'shopify_import/data_fetchers/orders_fetcher' } do
    it 'enqueue a job' do
      expect { subject.import! }.to have_enqueued_job(ShopifyImport::Importers::OrderImporterJob).once
    end
  end
end
