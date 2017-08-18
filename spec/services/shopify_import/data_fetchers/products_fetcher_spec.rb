require 'spec_helper'

RSpec.describe ShopifyImport::DataFetchers::ProductsFetcher, type: :service do
  describe '#import!' do
    subject { described_class.new(params) }

    before { authenticate_with_shopify }

    context 'with params', vcr: { cassette_name: 'shopify_import/products_importer/import_with_params' } do
      let(:params) { { created_at_min: '2017-06-04T15:00:00+02:00' } }

      it 'calls importer job' do
        expect { subject.import! }.to have_enqueued_job(ShopifyImport::Importers::ProductImporterJob).once
      end
    end

    context 'without params', vcr: { cassette_name: 'shopify_import/products_importer/import' } do
      let(:params) { {} }

      it 'calls importer job' do
        expect { subject.import! }.to have_enqueued_job(ShopifyImport::Importers::ProductImporterJob).twice
      end
    end
  end
end
